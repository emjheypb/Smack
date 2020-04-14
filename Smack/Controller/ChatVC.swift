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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController().panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController().tapGestureRecognizer())!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.userDataDidChange(_:)), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatVC.channelSelected(_:)), name: NOTIF_CHANNEL_SELECTED, object: nil)
        
        doneLoading(true)
        
        if AuthService.instance.isLoggedIn {
            self.doneLoading(false)
            
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
                
            }
        }
    }
    
    func updateWithChannel() {
        let name = MessageService.instance.selectedChannel?.name ?? ""
        channelLbl.text = "#\(name)"
    }
    
}
