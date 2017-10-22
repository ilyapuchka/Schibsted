//
//  ChatService.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import Foundation

extension URLRequest {
    static func chatsRequest() -> URLRequest {
        return request(URLComponents().with {
            $0.path = "/chat.json"
        })
    }
}

class ChatService {
    let networkSession: NetworkSession
    init(networkSession: NetworkSession) {
        self.networkSession = networkSession
    }
    
    func getChatMessages(_ completion: @escaping ([Message]?, Error?) -> Void) {
        networkSession.request(.chatsRequest()) { (decoded: [String: [Message]]?, _, _, error) in
            completion(decoded?["chats"], error)
        }
    }
}
