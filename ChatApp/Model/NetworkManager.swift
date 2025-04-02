import Foundation
import SwiftUI

struct ServerResponse: Codable {
    let expires_at: Double
    let response: ChatResponseContent
    let session_id: String
}

enum ChatResponseContent: Codable {
    case text(String)
    case card(CardInfo)

    struct CardInfo: Codable {
        let apply_now_url: String
        let descriptions: String
        let image_url: String
        let learn_more_url: String
        let title: String
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .text(string)
        } else if let card = try? container.decode(CardInfo.self) {
            self = .card(card)
        } else {
            throw DecodingError.typeMismatch(
                ChatResponseContent.self,
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unknown format")
            )
        }
    }
}

class NetworkManager {
    static func sendMessage(userInput: String, sessionId: String?, completion: @escaping (Message?, String?) -> Void) {
        guard let url = URL(string: "http://192.168.1.10:5200/query") else { return }

        let payload: [String: Any] = [
            "user_input": userInput,
            "session_id": sessionId as Any
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: payload) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completion(nil, sessionId)
                return
            }

            do {
                let json = try JSONDecoder().decode(ServerResponse.self, from: data)
                let message: Message
                switch json.response {
                case .text(let text):
                    message = Message(content: text, role: .system)
                case .card(let card):
                    if let jsonData = try? JSONEncoder().encode(card),
                       let jsonString = String(data: jsonData, encoding: .utf8) {
                        message = Message(content: "[CARD]" + jsonString, role: .system)
                    } else {
                        message = Message(content: "Failed to decode card info", role: .system)
                    }
                }
                DispatchQueue.main.async {
                    completion(message, json.session_id)
                }
            } catch {
                print("Decoding error: \(error)")
                DispatchQueue.main.async {
                    completion(nil, sessionId)
                }
            }
        }.resume()
    }
}
