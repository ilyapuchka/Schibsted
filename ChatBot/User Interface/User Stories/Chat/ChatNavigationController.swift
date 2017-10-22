//
//  ChatNavigationController.swift
//  ChatBot
//
//  Created by Ilya Puchka on 22/10/2017.
//  Copyright © 2017 Schibsted. All rights reserved.
//

import UIKit

protocol ChatFlowController: class {
    func logout()
}

class ChatNavigationController: UINavigationController, ChatFlowController {

    weak var flowController: RootFlowController?
    weak var chatViewController: ChatViewController?
    var service: ChatService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chatViewController = viewControllers[0] as? ChatViewController
        chatViewController?.service = service
        chatViewController?.flowController = self
    }
    
    func logout() {
        flowController?.logout()
    }

}
