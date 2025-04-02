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
        let input = userInput
        userInput = ""
        
        NetworkManager.sendMessage(userInput: input, sessionId: sessionId) { responseMessage, newSessionId in
            if let message = responseMessage {
                self.messages.append(message)
            }
            self.sessionId = newSessionId
        }
    }
}
