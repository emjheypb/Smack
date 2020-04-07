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
        
        spinner.isHidden = true
        
        if AuthService.instance.isLoggedIn {
            spinner.isHidden = false
            spinner.startAnimating()
            
            AuthService.instance.findUserByEmail() { (success) in
                if success {
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                } else {
                    UserDataService.instance.logoutUser()
                    
                    self.spinner.isHidden = true
                    self.spinner.stopAnimating()
                }
            }
        }
    }

}
