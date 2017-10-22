//
//  ViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, KeyboardObserver {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet var verticalConstraint: NSLayoutConstraint!
    
    var service: ChatService = ChatServiceImp(networkSession: URLSession.shared, userDefaults: UserDefaults.standard)

    @IBAction func showChat(_ sender: AnyObject?) {
        guard let username = textField.text, !username.isEmpty else { return }
        
        service.login(username: username)
        self.performSegue(withIdentifier: "gotoChat", sender: nil)
    }
    
    var keyboardObservers: [Any] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardObserving(
            in: scrollView,
            onKeyboardAppear: { [unowned self] _ in
                self.verticalConstraint.isActive = false
            },
            onKeyboardDisapear: { [unowned self] _ in
                self.verticalConstraint.isActive = true
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        stopKeyboardObserving()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        showChat(nil)
        return true
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        textField.resignFirstResponder()
    }
    
}
