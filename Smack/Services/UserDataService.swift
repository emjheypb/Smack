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
    static let instance = UserDataService()
    
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
}
