//
//  RootViewController.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import UIKit
import Rswift

protocol RootFlowController: class {
    func showChat()
    func logout()
}

class RootViewController: UIViewController, SeguePerformer, RootFlowController {

    weak var loginViewController: LoginViewController?
    weak var chatNavigationController: ChatNavigationController?
    
    let chatService: ChatService = {
        let messagesRepo = NetworkMessagesRepository(networkSession: URLSession.shared)
        let userRepo = DefaultsUserRepository(userDefaults: UserDefaults.standard)
        return ChatServiceImp(messagesRepository: messagesRepo, userRepository: userRepo)
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // show initial screen
        _ = self.installLoginIfNeeded()
            || self.showChatIfNeeded()
    }
    
    lazy var segueManager: SegueManager = SegueManager(viewController: self)
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return isViewAppeared
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        segueManager.prepare(for: segue)
    }
    
}

// MARK: - Login

extension RootViewController {
    
    func shouldInstallLogin() -> Bool {
        return chatService.currentUser() == nil && loginViewController == nil
    }
    
    func logout() {
        chatNavigationController?.dismiss(animated: true, completion: nil)
        installLoginIfNeeded()
    }
    
    @discardableResult
    func installLoginIfNeeded() -> Bool {
        guard shouldInstallLogin() else { return false }
        installLogin()
        return true
    }
    
    func installLogin() {
        performSegue(R.segue.rootViewController.installLogin) { [unowned self] (segue) in
            segue.destination.service = self.chatService
            segue.source.loginViewController = segue.destination
            segue.destination.flowController = segue.source
        }
    }

}

// MARK: - Chat

extension RootViewController {
    
    func shouldShowChat() -> Bool {
        return chatService.currentUser() != nil && chatNavigationController == nil
    }

    @discardableResult
    func showChatIfNeeded() -> Bool {
        guard shouldShowChat() else { return false }
        showChat()
        return true
    }
    
    func showChat() {
        performSegue(R.segue.rootViewController.gotoChat) { [unowned self] segue in
            segue.destination.service = self.chatService
            segue.source.chatNavigationController = segue.destination
            segue.destination.flowController = segue.source
        }
    }
    
}
