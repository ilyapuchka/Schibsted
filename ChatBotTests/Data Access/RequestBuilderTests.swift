//
//  RequestBuilderTests.swift
//  ChatBotTests
//
//  Created by IIlya Puchka on 23.10.17.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import XCTest
@testable import ChatBot

class RequestBuilderTests: XCTestCase {

    func testThatItBuildsChatsRequest() {
        let request = URLRequest.chatsRequest()
        
        XCTAssertEqual(request.httpMethod, "GET")
        XCTAssertEqual(request.url?.scheme, "https")
        XCTAssertEqual(request.url?.host, "s3-eu-west-1.amazonaws.com")
        XCTAssertEqual(request.url?.path, "/rocket-interview/chat.json")
    }

}
