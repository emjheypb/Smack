//
//  ChatVC.swift
//  Smack
//
//  Created by Mariah Baysic on 4/1/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class ChatVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var channelLbl: UILabel!
    @IBOutlet weak var messageTxtbx: UITextField!
    @IBOutlet weak var messagesTbl: UITableView!
    @IBOutlet weak var sendBtn: UIButton!
    @IBOutlet weak var typingUsersLbl: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard(_:)))
        view.addGestureRecognizer(tap)

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController().panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController().tapGestureRecognizer())!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        messagesTbl.delegate = self
        messagesTbl.dataSource = self
        
        messagesTbl.estimatedRowHeight = 80
        messagesTbl.rowHeight = UITableView.automaticDimension
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: sendBtn.frame.size.width, height: messageTxtbx.frame.size.height))
        messageTxtbx.rightView = paddingView
        messageTxtbx.rightViewMode = .always
        
        view.bringSubviewToFront(spinner)
        
        doneLoading(true)
        
        if AuthService.instance.isLoggedIn {
            self.doneLoading(false)
            print(AuthService.instance.authToken)
            
            AuthService.instance.findUserByEmail() { (success) in
                if success {
                    self.doneLoading(true)
                    NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                } else {
                    UserDataService.instance.logoutUser()
                    self.doneLoading(true)
                }
            }
        }

        SocketService.instance.getMessages { (newMessage) in
            if newMessage.channelID == MessageService.instance.selectedChannel?.id && AuthService.instance.isLoggedIn {
                MessageService.instance.messages.append(newMessage)
                self.messagesTbl.reloadData()
                if MessageService.instance.messages.count > 0 {
                    self.messagesTbl.scrollToRow(at: IndexPath(row: MessageService.instance.messages.count - 1, section: 0), at: .bottom, animated: true)
                }
            }
        }
//        SocketService.instance.getMessages { (success) in
//            if success {
//                self.messagesTbl.reloadData()
//                self.messagesTbl.scrollToRow(at: IndexPath(row: self.messagesTbl.numberOfRows(inSection: 0) - 1, section: 0), at: .bottom, animated: true)
//            }
//        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
        
            if AuthService.instance.isLoggedIn {
                guard let channelID = MessageService.instance.selectedChannel?.id else { return }
                var names = ""
                
                for (typingUser, channel) in typingUsers {
                    if typingUser != UserDataService.instance.name && channel == channelID {
                        if names == "" {
                            names += typingUser
                        } else {
                            names += ", \(typingUser)"
                        }
                    }
                }
                
                if names != "" {
                    names += " typing..."
                }
                
                self.typingUsersLbl.text = "\(names)"
            }
        }
    }
    
    @objc func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func doneLoading(_ stat: Bool) {
        spinner.isHidden = stat
        menuBtn.isEnabled = stat
        
        if stat {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        } else {
            channelLbl.text = "SMACK"
            typingUsersLbl.text = ""
            messagesTbl.reloadData()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
        
        if !sendBtn.isHidden {
            guard let channelID = MessageService.instance.selectedChannel?.id else { return }
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelID)
        }
    }

    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    
                    self.updateWithChannel()
                } else {
                    self.channelLbl.text = "No Channels"
                }
            }
        }
    }
    
    func updateWithChannel() {
        let name = MessageService.instance.selectedChannel?.name ?? ""
        channelLbl.text = "#\(name)"
        getMessages()
    }
    
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelID = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTxtbx.text else { return }
            
            SocketService.instance.newMessage(messageBody: message, channelID: channelID) { (success) in
                if success{
                    SocketService.instance.socket.emit("stopType", UserDataService.instance.name)

                    self.isTyping = false
                    self.sendBtn.isHidden = !self.isTyping
                    
                    self.messageTxtbx.text = ""
                    self.messageTxtbx.resignFirstResponder()
                }
            }
        }
    }
    
    func getMessages() {
        MessageService.instance.getAllChannelMessages { (success) in
            self.messagesTbl.reloadData()
            if MessageService.instance.messages.count > 0 {
                self.messagesTbl.scrollToRow(at: IndexPath(row: MessageService.instance.messages.count - 1, section: 0), at: .bottom, animated: false)
            }
            
            if !self.sendBtn.isHidden {
                guard let channelID = MessageService.instance.selectedChannel?.id else { return }
                SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelID)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = messagesTbl.dequeueReusableCell(withIdentifier: "MessageCell", for: indexPath) as? MessageCell {
            
            cell.configureCell(message: MessageService.instance.messages[indexPath.row])
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    @IBAction func messageBoxIsEditing(_ sender: Any) {
        if messageTxtbx.text == "" {
            isTyping = false
            sendBtn.isHidden = !isTyping
            
            SocketService.instance.socket.emit("stopType", UserDataService.instance.name)
        } else {
            isTyping = true
            sendBtn.isHidden = !isTyping
            
            guard let channelID = MessageService.instance.selectedChannel?.id else { return }
            
            SocketService.instance.socket.emit("startType", UserDataService.instance.name, channelID)
        }
    }
    
}
