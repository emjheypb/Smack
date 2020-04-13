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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController().panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController().tapGestureRecognizer())!)
        
        doneLoading(true)
        
        if AuthService.instance.isLoggedIn {
            self.doneLoading(false)
            
            AuthService.instance.findUserByEmail() { (success) in
                if success {
                    MessageService.instance.findAllChannels { (success) in
                        if success {
                            self.doneLoading(true)
                        } else {
                            UserDataService.instance.logoutUser()
                            self.doneLoading(true)
                        }
                    }
                } else {
                    UserDataService.instance.logoutUser()
                    self.doneLoading(true)
                }
            }
        }
    }
    
    func doneLoading(_ stat: Bool) {
        spinner.isHidden = stat
        
        if stat {
            spinner.stopAnimating()
        } else {
            spinner.startAnimating()
        }
    }

}
