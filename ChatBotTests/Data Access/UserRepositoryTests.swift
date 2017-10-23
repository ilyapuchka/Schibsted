//
//  UserRepositoryTests.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import XCTest
@testable import ChatBot

class UserRepositoryTests: XCTestCase {
    
    let userDefaults: UserDefaults = UserDefaults(suiteName: String(describing: type(of: self)))!
    let username = "ilya"
    
    override func tearDown() {
        super.tearDown()
        userDefaults.username = nil
        userDefaults.synchronize()
    }
    
    func testThatItCanLogin() {
        // given
        let sut = DefaultsUserRepository(userDefaults: userDefaults)
        
        // when
        sut.login(username: username)
        
        // then
        XCTAssertEqual(userDefaults.username, username)
    }
    
    func testThatItCanLogout() {
        // given
        let sut = DefaultsUserRepository(userDefaults: userDefaults)
        
        // when
        sut.login(username: username)
        sut.logout()
        
        // then
        XCTAssertNil(userDefaults.username)
    }
    
    func testThatItCanGetCurrentCustomer() {
        // given
        let sut = DefaultsUserRepository(userDefaults: userDefaults)
        
        // when
        sut.login(username: username)
        
        // then
        XCTAssertEqual(sut.currentUser(), username)
    }
    
}
