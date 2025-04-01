//
//  ChatView.swift
//  ChatApp
//
//  Created by Renchi Liu on 3/14/25.
//

import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var userInput: String = ""
    @State private var sessionId: String? = nil
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(messages) { message in
                        ChatBubble(message: message)
                    }
                }
            }
            HStack {
                TextField("Enter message", text: $userInput)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Send") {
                    sendMessage()
                }
            }
            .padding()
        }
    }
    
    func sendMessage() {
        guard !userInput.isEmpty else { return }
        let userMessage = Message(content: userInput, role: .user)
        messages.append(userMessage)
        userInput = ""
        receiveMessage()
    }
    
    func testGetInfo() {
        guard let url = URL(string: "http://192.168.1.10:5200/info") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("No HTTP response")
                return
            }
            
            print("Status code: \(httpResponse.statusCode)")
            
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                print("Failed to decode JSON")
                return
            }
            
            print("GET /info response: \(json)")
        }.resume()
    }

    
    func receiveMessage() {
    
        guard let url = URL(string: "http://192.168.1.10:5200/query") else { return }
        
        let payload: [String: Any] = [
            "user_input": userInput,
            "session_id": sessionId as Any // nil sends a new session
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let responseText = json["response"] as? String else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.sessionId = json["session_id"] as? String
                let systemMessage = Message(content: responseText, role: .system)
                self.messages.append(systemMessage)
            }
        }.resume()
    }

}

//#Preview {
//    ChatView()
//}
