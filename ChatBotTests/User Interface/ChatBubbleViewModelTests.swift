//
//  ChatBubbleViewModelTests.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import XCTest
@testable import ChatBot

class ChatBubbleViewModelTests: XCTestCase {
    
    func testThatItFormatsUsernameCorrectly() throws {
        let data = try Data(resource: R.file.messageJson)
        let message = try JSONDecoder().decode(Message.self, from: data)
        messageTimeViewFormatter.locale = Locale(identifier: "en_US_POSIX")

        let userMessage = ChatBubbleViewModel<UserSenderType>(message: message)
        XCTAssertEqual(userMessage.username, "12:00 PM")
        
        let friendMessage = ChatBubbleViewModel<FriendSenderType>(message: message)
        XCTAssertEqual(friendMessage.username, "Valerie - 12:00 PM")
    }
    
    
}
