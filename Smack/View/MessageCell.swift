//
//  MessageCell.swift
//  Smack
//
//  Created by Mariah Baysic on 4/30/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var userImage: CircleImage!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var timeStampLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureCell (message: Message) {
        let date = message.timeStamp.split(separator: "T")
        let time = date[1].split(separator: ".")
        let hms = time[0].split(separator: ":")
        
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userNameLbl.text = message.userName
        timeStampLbl.text = "\(date[0]) \(hms[0]):\(hms[1])"
        messageLbl.text = message.message
    }

}
