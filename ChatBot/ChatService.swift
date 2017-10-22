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

protocol ChatService {
    func getChatMessages() -> Promise<[Message]>
    
    func login(username: String)
    func logout()
    func currentUser() -> String?
}

class ChatServiceImp: ChatService {
    let networkSession: NetworkSession
    let userDefaults: UserDefaults
    
    init(networkSession: NetworkSession, userDefaults: UserDefaults) {
        self.networkSession = networkSession
        self.userDefaults = userDefaults
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
    
    func login(username: String) {
        userDefaults.username = username
    }
    
    func logout() {
        userDefaults.username = nil
    }
    
    func currentUser() -> String? {
        return userDefaults.username
    }
    
}

extension UserDefaults {
    
    var username: String? {
        get { return value(forKey: #function) as? String }
        set { setValue(newValue, forKey: #function) }
    }
    
}
