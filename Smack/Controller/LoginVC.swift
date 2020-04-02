//
//  LoginVC.swift
//  Smack
//
//  Created by Mariah Baysic on 4/1/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func createAccountBtnPressed(_ sender: Any) {
        UserDataService.instance.setAvatarName(name: "profileDefault")
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        guard let email = emailTxt.text, emailTxt.text != "" else { return }
        guard let pass = passwordTxt.text, passwordTxt.text != "" else { return }
        
        AuthService.instance.loginUser(email: email, password: pass) { (success) in
            if success {
                print("Login Successful", AuthService.instance.authToken, UserDataService.instance.name)
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
