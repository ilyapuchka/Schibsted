//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, KeyboardObserver {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            //registerReusableViews()
            tableView.register(UserChatBubble.nib)
            tableView.register(FriendChatBubble.nib)
        }
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet var inputViewBottomConstraint: NSLayoutConstraint!
    
    var keyboardObservers: [Any] = []
    
    var service: ChatService = ChatService(networkSession: URLSession.shared)
    //var model = ChatModel(messages: [])
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputChanged(nil)
        
        service.getChatMessages().then { [weak self] (messages) in
            //self?.model = ChatModel(messages: messages)
            self?.messages = messages
            self?.tableView.reloadData()
            self?.scrollToBottom(animated: false)
        }
    }
    
    func keyboardEndFrame(_ note: Notification) -> CGRect? {
        guard var frame = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        frame.size.height += inputViewHeight
        return frame
    }
    
    var inputViewHeight: CGFloat {
        return inputTextField.superview?.frame.height ?? 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startKeyboardObserving(
            in: tableView,
            onKeyboardAppear: { [unowned self] note in
                if let keyboardFrame = self.keyboardEndFrame(note) {
                    self.inputViewBottomConstraint.constant = keyboardFrame.height - self.inputViewHeight
                }
                self.scrollToBottom(animated: true)
            },
            onKeyboardDisapear: { [unowned self] _ in
                self.inputViewBottomConstraint.constant = 0
            }
        )
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        stopKeyboardObserving()
    }
    
    func scrollToBottom(animated: Bool) {
        let indexPath = IndexPath(
            row: self.tableView(self.tableView, numberOfRowsInSection: 0) - 1,
            section: 0
        )
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        inputTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        sendMessage(nil)
        return true
    }
    
    @IBAction func inputChanged(_ sender: UITextField?) {
        sendButton.isEnabled = sender?.text?.isEmpty == false
    }
    
    @IBAction func sendMessage(_ sender: UIButton?) {
        guard let text = inputTextField.text, !text.isEmpty else { return }
        
        inputTextField.text = ""
        inputChanged(inputTextField)
        
        tableView.beginUpdates()
        let indexPath = IndexPath(row: messages.count, section: 0)
        tableView.insertRows(at: [indexPath], with: .fade)
        self.messages += [
            Message(
                username: UserDefaults.standard.value(forKey: "username") as! String,
                time: "now",
                userImageURL: nil,
                content: text)
        ]
        tableView.endUpdates()
        UIView.animate(withDuration: 0.25) {
            let cell = self.tableView.cellForRow(at: indexPath)!
            self.tableView.contentOffset.y += cell.frame.size.height
        }
    }
    
}

extension ChatViewController/*: ListView*/ {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
        //return numberOfRows()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let username = UserDefaults.standard.value(forKey: "username") as? String

        if message.username == username {
            let userChatBubble = tableView.dequeueReusableCell(withIdentifier: UserChatBubble.reuseIdentifier, for: indexPath)!
            let model = ChatBubbleViewModel<UserSenderType>(message: message)
            userChatBubble.update(withViewModel: model)
            return userChatBubble
        } else {
            let friendChatBubble = tableView.dequeueReusableCell(withIdentifier: FriendChatBubble.reuseIdentifier, for: indexPath)!
            let model = ChatBubbleViewModel<FriendSenderType>(message: message)
            friendChatBubble.update(withViewModel: model)
            return friendChatBubble
        }
        //return cellForRow(at: indexPath)
    }
    
}

//struct ChatModel: ListViewModel {
//
//    typealias Item = AnyChatBubbleViewModel
//    typealias Cell = AnyChatBubble
//
//    let messages: [AnyChatBubbleViewModel]
//
//    init(messages: [Message]) {
//        self.messages = messages.map(AnyChatBubbleViewModel.init(message:))
//    }
//
//    func numberOfRows() -> Int {
//        return messages.count
//    }
//
//    func item(at index: Int) -> Item? {
//        guard index < messages.count else { return nil }
//        return messages[index]
//    }
//
//}

