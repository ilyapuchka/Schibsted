//
//  ChatViewController.swift
//  ChatBot
//
//  Created by Muge Ersoy on 21/04/2016.
//  Copyright © 2016 Schibsted. All rights reserved.
//

import UIKit
import NextGrowingTextView

class ChatViewController: UIViewController, KeyboardObserver {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.register(UserChatBubble.nib)
            tableView.register(FriendChatBubble.nib)
        }
    }
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var inputTextView: NextGrowingTextView! {
        didSet {
            inputTextView.maxNumberOfLines = 5
            inputTextView.placeholderAttributedText = NSAttributedString(
                string: NSLocalizedString("Type something", comment: ""),
                attributes: [
                    NSAttributedStringKey.font: inputTextView.textView.font!,
                    NSAttributedStringKey.foregroundColor: UIColor.lightGray
                ]
            )
            inputTextView.textView.delegate = self
        }
    }
    @IBOutlet var inputViewBottomConstraint: NSLayoutConstraint!
    
    var keyboardObservers: [Any] = []
    
    var service: ChatService!
    weak var flowController: ChatFlowController?
    
    var messages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = String(format: "%@ - \(service.currentUser()!)", NSLocalizedString("Chat", comment: "Chat title"))
        textViewDidChange(inputTextView.textView)
        
        service.getChatMessages().then { [weak self] (messages) in
            self?.messages = messages
            self?.tableView.reloadData()
            self?.scrollToBottom(animated: false)
        }
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
    
    func keyboardEndFrame(_ note: Notification) -> CGRect? {
        guard var frame = note.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect else { return nil }
        frame.size.height += inputViewHeight
        return frame
    }
    
    @IBAction func tapped(_ sender: UITapGestureRecognizer) {
        _ = inputTextView.resignFirstResponder()
    }
    
}

// MARK: - Actions

extension ChatViewController {

    @IBAction func sendMessage(_ sender: UIButton?) {
        guard let text = inputTextView.textView.text, !text.isEmpty else { return }
        
        inputTextView.textView.text = ""
        insertMessage(Message(username: service.currentUser()!, time: "now", userImageURL: nil, content: text),
                      at: IndexPath(row: messages.count, section: 0))
    }
    
    @IBAction func logout() {
        inputTextView.textView.resignFirstResponder()
        service.logout()
        flowController?.logout()
    }

}

// MARK: - Text Input

extension ChatViewController: UITextViewDelegate {
    
    var inputViewHeight: CGFloat {
        return inputTextView.superview?.frame.height ?? 0
    }

    func textViewDidChange(_ textView: UITextView) {
        sendButton.isEnabled = textView.text?.isEmpty == false
    }
}

// MARK: - Table View

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]

        if message.username == service.currentUser() {
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
    }
    
    func scrollToBottom(animated: Bool) {
        let indexPath = IndexPath(
            row: tableView(tableView, numberOfRowsInSection: 0) - 1,
            section: 0
        )
        tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
    }

    func insertMessage(_ message: Message, at indexPath: IndexPath) {
        messages += [message]

        tableView.beginUpdates()
        let animationDuration = CATransaction.animationDuration()
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()

        // If we already at the bottom, doing `scrollToBottom` causes
        // unneeded change of offset before animation starts, which does not look nice,
        // so we adjust content offset manually to make cell fully visible.
        // But if content is scrolled so that new cell is not visible, `cellForRow` will return nil,
        // so we fallback to `scrollToBottom` which animates nice in that case
        UIView.animate(withDuration: animationDuration) {
            if let cell = self.tableView.cellForRow(at: indexPath) {
                self.tableView.scrollRectToVisible(cell.frame, animated: true)
            } else {
                self.scrollToBottom(animated: true)
            }
        }
    }
    
}
