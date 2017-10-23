//
//  ChatBotUITests.swift
//  ChatBotUITests
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import XCTest

class ChatBotUITests: XCTestCase {

    let app = XCUIApplication()

    func startApp(username: String) {
        continueAfterFailure = false
        app.launchArguments = ["-username", username]
        app.launch()
    }
    
    func typeMessage(message: String) {
        let inputView = app.textViews.firstMatch
        inputView.tap()
        inputView.typeText(message)
    }
    
    func sendMessage(message: String) {
        typeMessage(message: message)
        app.buttons["SEND"].tap()
    }
    
    func login(username: String) {
        let textField = app.textFields.firstMatch
        textField.tap()
        textField.typeText(username)
        app.buttons["LOGIN"].tap()
    }

    func testThatItShowsLoginScreenIfNotLoggedInOnStartup() {
        // given
        startApp(username: "")
        
        // then
        XCTAssertTrue(app.buttons["LOGIN"].waitForExistence(timeout: 5.0))
    }
    
    func testThatItShowsChatScreenIfLoggedInOnStartup() {
        // given
        startApp(username: "ilya")
        
        // then
        XCTAssertTrue(app.navigationBars["Chat - ilya"].waitForExistence(timeout: 5.0))
    }
    
    func testThatItCanLogin() {
        // given
        startApp(username: "")
        
        // when
        login(username: "username")
        
        // then
        XCTAssertTrue(app.navigationBars["Chat - username"].waitForExistence(timeout: 5.0))
    }
    
    func testThatItAddsNewMessage() {
        // given
        startApp(username: "ilya")
        
        // when
        sendMessage(message: "New message")
        
        // then
        XCTAssertTrue(app.cells.staticTexts["New message"].exists)
    }
    
    func testThatSendButtonIsEnabledWhenTextInputIsNotEmpty() {
        // given
        startApp(username: "ilya")

        let sendButton = app.buttons["SEND"]
        XCTAssertFalse(sendButton.isEnabled)
        
        // when
        typeMessage(message: "New message")

        // then
        XCTAssertTrue(sendButton.isEnabled)
    }
    
}

