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
    private var username: String?
    
    init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    func login(username: String) {
        self.username = username
        userDefaults.username = username
    }
    
    func logout() {
        self.username = nil
        userDefaults.username = nil
    }
    
    func currentUser() -> String? {
        return username ?? userDefaults.username
    }
}

extension UserDefaults {
    
    var username: String? {
        get {
            guard let value = value(forKey: #function) as? String, !value.isEmpty else { return nil }
            return value
        }
        set {
            setValue(newValue, forKey: #function)
            synchronize()
        }
    }
    
}
