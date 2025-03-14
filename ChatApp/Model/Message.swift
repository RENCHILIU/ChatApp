//
//  Message.swift
//  ChatApp
//
//  Created by Renchi Liu on 3/14/25.
//
import Foundation

enum Role {
    case system
    case user
}

enum RoleAvatar: String {
    case system = "dollarsign.bank.building.fill"
    case user = "person.crop.circle.fill"
}


struct Message: Identifiable {
    let id = UUID()
    let content: String
    let role: Role
}

