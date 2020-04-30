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
        
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = UserDataService.instance.returnUIColor(components: message.userAvatarColor)
        userNameLbl.text = message.userName
        messageLbl.text = message.message
        
//        let date = message.timeStamp.split(separator: "T")
//        let time = date[1].split(separator: ".")
//        let hms = time[0].split(separator: ":")
//
//        timeStampLbl.text = "\(date[0]) \(hms[0]):\(hms[1])"
        guard var isoDate = message.timeStamp else { return }
        let end = isoDate.index(isoDate.endIndex, offsetBy: -5)
        isoDate = String(isoDate.prefix(upTo: end))
        
        let isoFormatter = ISO8601DateFormatter()
        let chatDate = isoFormatter.date(from: isoDate.appending("Z"))
        
        let newFormatter = DateFormatter()
        newFormatter.dateFormat = "MMM d, h:mm a"
        
        if let finalDate = chatDate {
            let finalDate = newFormatter.string(from: finalDate)
            timeStampLbl.text = finalDate
        }
    }

}
