//
//  ChatView.swift
//  ChatApp
//
//  Created by Renchi Liu on 3/14/25.
//

import SwiftUI

import SwiftUI

struct ChatView: View {
    @State private var messages: [Message] = []
    @State private var userInput: String = ""
    
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
    
    func receiveMessage() {
        //TODO:
        let systemMessage = Message(content: "Connect With BackEnd", role: .system)
        messages.append(systemMessage)
    }
}


#Preview {
    ChatView()
}
