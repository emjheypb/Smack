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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        menuBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer((self.revealViewController().panGestureRecognizer())!)
        self.view.addGestureRecognizer((self.revealViewController().tapGestureRecognizer())!)
    }

}
