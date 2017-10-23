//
//  MessagesRepositoryTests.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import XCTest
@testable import ChatBot

class MessagesRepositoryTests: XCTestCase {
    
    func testThatItCanGetChats() throws {
        let data = try Data(resource: R.file.chatJson)
        let chats = try JSONDecoder().decode([String: [Message]].self, from: data)

        let fileSession = FileNetworkSession()
        fileSession.responses[.chatsRequest()] = chats
        
        let sut = NetworkMessagesRepository(networkSession: fileSession)
        
        let receivedChats = expectation(description: "Received chats")
        sut.getChatMessages().then({ messages in
            AssertNotDiff(messages, chats["chats"])
            receivedChats.fulfill()
        }) { (error) in
            XCTFail("Request should not fail")
            receivedChats.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testThatItReturnsBadResponseError() throws {
        let data = try Data(resource: R.file.chatJson)
        var chats = try JSONDecoder().decode([String: [Message]].self, from: data)
        chats["items"] = chats["chats"]
        chats["chats"] = nil
        
        let fileSession = FileNetworkSession()
        fileSession.responses[.chatsRequest()] = chats
        
        let sut = NetworkMessagesRepository(networkSession: fileSession)
        
        let receivedChats = expectation(description: "Received chats")
        sut.getChatMessages().then({ messages in
            XCTFail("Request should not succeed")
            receivedChats.fulfill()
        }) { (error) in
            XCTAssertEqual(error as? URLError, URLError(URLError.badServerResponse))
            receivedChats.fulfill()
        }
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
}
