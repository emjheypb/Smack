//
//  CreateChannelVC.swift
//  Smack
//
//  Created by Mariah Baysic on 4/13/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class CreateChannelVC: UIViewController {

    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var descriptionTxt: UITextField!
    @IBOutlet weak var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

    @IBAction func closeBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createChannelPressed(_ sender: Any) {
        guard let name = nameTxt.text, nameTxt.text != "" else { return }
        guard let description = descriptionTxt.text, descriptionTxt.text != "" else { return }
        
        MessageService.instance.createChannel(name: name, description: description) { (success) in
            if success {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    func setupView() {
        nameTxt.attributedPlaceholder = NSAttributedString(string: "name", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceholder])
        descriptionTxt.attributedPlaceholder = NSAttributedString(string: "description", attributes: [NSAttributedString.Key.foregroundColor : smackPurplePlaceholder])
        
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(CreateChannelVC.closeTouch(_:)))
        backgroundView.addGestureRecognizer(closeTap)
    }

    @objc func closeTouch(_ recognizer: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}
