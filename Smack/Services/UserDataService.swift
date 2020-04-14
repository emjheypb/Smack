//
//  UserDataService.swift
//  Smack
//
//  Created by Mariah Baysic on 4/2/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//
//  To be able to access user data instance in the whole app

import Foundation

class UserDataService {
    static let instance = UserDataService()  // Singleton
    
    public private(set) var id = ""
    public private(set) var avatarColor = ""
    public private(set) var avatarName = ""
    public private(set) var email = ""
    public private(set) var name = ""
    
    func setUserData(id: String, color: String, avatarName: String, email: String, name: String) {
        self.id = id
        self.avatarColor = color
        self.avatarName = avatarName
        self.email = email
        self.name = name
    }
    
    func setAvatarName(name: String) {
        self.avatarName = name
    }
    
    func returnUIColor(components: String) -> UIColor {

        let scanner = Scanner(string: components)
        let skipped = CharacterSet(charactersIn: "[], ")
        let comma = CharacterSet(charactersIn: ",")

        scanner.charactersToBeSkipped = skipped
        
        let r = scanner.scanUpToCharacters(from: comma) as NSString?
        let g = scanner.scanUpToCharacters(from: comma) as NSString?
        let b = scanner.scanUpToCharacters(from: comma) as NSString?
        let a = scanner.scanUpToCharacters(from: comma) as NSString?

        let defaultColor = UIColor.lightGray

        guard let rUnwrapped = r else { return defaultColor}
        guard let gUnwrapped = g else { return defaultColor}
        guard let bUnwrapped = b else { return defaultColor}
        guard let aUnwrapped = a else { return defaultColor}

        let rFloat = CGFloat(rUnwrapped.doubleValue)
        let gFloat = CGFloat(gUnwrapped.doubleValue)
        let bFloat = CGFloat(bUnwrapped.doubleValue)
        let aFloat = CGFloat(aUnwrapped.doubleValue)

        let newUIColor = UIColor(red: rFloat, green: gFloat, blue: bFloat, alpha: aFloat)

        return newUIColor
    }
    
    func logoutUser() {
        self.id = ""
        self.avatarColor = ""
        self.avatarName = ""
        self.email = ""
        self.name = ""
        
        AuthService.instance.isLoggedIn = false
        AuthService.instance.userEmail = ""
        AuthService.instance.authToken = ""
        
        MessageService.instance.clearChannels()
    }
}
