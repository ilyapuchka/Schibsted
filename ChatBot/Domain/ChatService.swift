//
//  ChatService.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import Foundation

protocol ChatService {
    func getChatMessages() -> Promise<[Message]>
    
    func login(username: String)
    func logout()
    func currentUser() -> String?
}

class ChatServiceImp: ChatService {
    let messagesRepository: MessagesRepository
    let userRepository: UserRepository
    
    init(messagesRepository: MessagesRepository, userRepository: UserRepository) {
        self.messagesRepository = messagesRepository
        self.userRepository = userRepository
    }
    
    func getChatMessages() -> Promise<[Message]> {
        return messagesRepository.getChatMessages()
    }
    
    func login(username: String) {
        userRepository.login(username: username)
    }
    
    func logout() {
        userRepository.logout()
    }
    
    func currentUser() -> String? {
        return userRepository.currentUser()
    }

}

protocol MessagesRepository {
    func getChatMessages() -> Promise<[Message]>
}

protocol UserRepository {
    func login(username: String)
    func logout()
    func currentUser() -> String?

}

extension UserDefaults {
    
    var username: String? {
        get { return value(forKey: #function) as? String }
        set { setValue(newValue, forKey: #function) }
    }
    
}
