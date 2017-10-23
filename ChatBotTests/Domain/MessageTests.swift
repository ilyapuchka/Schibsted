//
//  MessageTests.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import XCTest
@testable import ChatBot

class MessageTests: XCTestCase {
    
    func testThatMessageIsDecodable() throws {
        let data = try Data(resource: R.file.messageJson)
        let message = try JSONDecoder().decode(Message.self, from: data)

        XCTAssertEqual(message.username, "Valerie")
        XCTAssertEqual(message.content, " Exactly, sir.")
        XCTAssertEqual(message.userImageURL, URL(string: "https://pbs.twimg.com/profile_images/1901163212/Profile_Picture_normal.png"))
        XCTAssertEqual(message.time, messageTimeDecodingFormatter.date(from: "12:00h"))
    }
    
}
