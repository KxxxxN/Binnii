//
//  ContactUsRequest.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 29/4/2569 BE.
//


import Foundation
import Supabase

struct ContactUsRequest: Encodable {
    let name: String
    let email: String
    let subject: String
    let message: String
    let createdAt: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case email
        case subject
        case message
        case createdAt = "created_at"
    }
}

struct ContactUsService {
    
    func sendMessage(name: String, email: String, subject: String, message: String) async throws {
        let body = ContactUsRequest(
            name: name,
            email: email,
            subject: subject,
            message: message,
            createdAt: ISO8601DateFormatter().string(from: Date())
        )
        
        try await supabase
            .from("contact_messages")
            .insert(body)
            .execute()
    }
}
