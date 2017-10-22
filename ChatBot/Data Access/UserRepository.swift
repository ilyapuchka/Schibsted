//
//  UserRepository.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import Foundation

class DefaultsUserRepository: UserRepository {
    let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func login(username: String) {
        userDefaults.username = username
        userDefaults.synchronize()
    }
    
    func logout() {
        userDefaults.username = nil
        userDefaults.synchronize()
    }
    
    func currentUser() -> String? {
        return userDefaults.username
    }
}
