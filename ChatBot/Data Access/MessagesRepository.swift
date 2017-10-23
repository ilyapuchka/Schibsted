//
//  MessagesRepository.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import Foundation

class NetworkMessagesRepository: MessagesRepository {
    let networkSession: NetworkSession

    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func getChatMessages() -> Promise<[Message]> {
        return networkSession.request(.chatsRequest()).then { (chats: [String: [Message]]) throws -> [Message] in
            if let messages = chats["chats"] {
                return messages
            } else {
                throw URLError(URLError.badServerResponse)
            }
        }
    }
}

extension URLRequest {
    static func chatsRequest() -> URLRequest {
        return request(URLComponents().with {
            $0.path = "/chat.json"
        })
    }
}
