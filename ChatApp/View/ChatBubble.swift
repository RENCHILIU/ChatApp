//
//  ChatBubble.swift
//  ChatApp
//
//  Created by Renchi Liu on 3/14/25.
//

import SwiftUI

struct ChatBubble: View {
    let message: Message
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.role == .user {
                Spacer()
                messageContent
                avatarView(for: .user)
            } else {
                avatarView(for: .system)
                messageContent
                Spacer()
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
    }
    
    @ViewBuilder
    private var messageContent: some View {
        if message.content.starts(with: "[CARD]"),
           let jsonData = message.content.dropFirst(6).data(using: .utf8),
           let card = try? JSONDecoder().decode(ChatResponseContent.CardInfo.self, from: jsonData) {
            CreditCardView(card: card)
        } else {
            Text(message.content)
                .padding()
                .background(backgroundColor(for: message.role))
                .foregroundColor(.white)
                .cornerRadius(10)
        }
    }
    
    @ViewBuilder
    func avatarView(for role: Role) -> some View {
        let avatarImageName: String = {
            switch role {
            case .system:
                return RoleAvatar.system.rawValue
            case .user:
                return RoleAvatar.user.rawValue
            }
        }()
        
        Image(systemName: avatarImageName)
            .resizable()
            .frame(width: 40, height: 40)
            .clipShape(Circle())
    }
    
    func backgroundColor(for role: Role) -> Color {
        role == .user ? Color.blue : Color.gray
    }
}


//#Preview {
//    ChatBubble(message: Message(content: "hello", role: .system))
//    ChatBubble(message: Message(content: "hellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohellohello", role: .user))
//}
