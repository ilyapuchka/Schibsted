//
//  NetworkSessionTests.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import XCTest
import Rswift
@testable import ChatBot

class NetworkSessionTests: XCTestCase {
    
    func testDataTaskCompletionHandlerDecodesResponse() throws {
        // given repo data
        let data = try Data(resource: R.file.chatJson)
        let chats = try JSONDecoder().decode([String: [Message]].self, from: data)
        
        // given response
        let response = HTTPURLResponse(url: URL(string: "https://s3-eu-west-1.amazonaws.com/rocket-interview/chat.json")!,
                                       statusCode: 200,
                                       httpVersion: nil,
                                       headerFields: [:])!
        
        let expectCompleted = expectation(description: "Completion handler called")
        let completionHandler = URLSession.shared.dataTaskCompletionHandler { (decoded: [String: [Message]]?, data, response, error) in
            XCTAssertNotNil(response)
            XCTAssertNotNil(data)
            XCTAssertNil(error)
            
            AssertNotDiff(chats, decoded)
            
            expectCompleted.fulfill()
        }
        
        completionHandler(data, response, nil)
        waitForExpectations(timeout: 1, handler: nil)
    }
    
}

