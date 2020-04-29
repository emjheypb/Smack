//
//  ChatVC.swift
//  Smack
//
//  Created by Mariah Baysic on 4/1/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class ChatVC: UIViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var channelLbl: UILabel!
    @IBOutlet weak var messageTxtbx: UITextField!
    
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
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
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
                    self.messageTxtbx.text = ""
                    self.messageTxtbx.resignFirstResponder()
                }
            }
        }
    }
    
    func getMessages() {
        MessageService.instance.getAllChannelMessages { (success) in
            
        }
    }
    
}
