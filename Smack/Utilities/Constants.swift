//
//  Constants.swift
//  Smack
//
//  Created by Mariah Baysic on 4/1/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation

typealias CompletionHandler = (_ Success: Bool) -> ()

// Segues
let TO_LOGIN = "toLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND = "unwindToChannel"
let TO_AVATAR_PICKER = "toAvatarPicker"

// User Defaults
let TOKEN_KEY = "token"
let LOGGED_IN_KEY = "loggedIn"
let USER_EMAIL = "userEmail"

// URL
let BASE_URL = "https://spacedout-smack.herokuapp.com/v1/"
let URL_REGISTER = "\(BASE_URL)account/register"
let URL_LOGIN = "\(BASE_URL)account/login"
let URL_ADD_USER = "\(BASE_URL)user/add"
let URL_GET_USER_BY_EMAIL = "\(BASE_URL)user/byEmail/"
let URL_GET_CHANNELS = "\(BASE_URL)channel"
let URL_CREATE_CHANNEL = "\(BASE_URL)channel/add"

// Headers
let HEADER = [
    "Content-Type" : "application/json; charset=utf-8"
]
let BEARER_HEADER = [
   "Authorization" : "Bearer \(AuthService.instance.authToken)",
   "Content-Type" : "application/json; charset=utf-8"
]

// Colors
let smackPurplePlaceholder = #colorLiteral(red: 0.3647058824, green: 0.4045833051, blue: 0.8775706887, alpha: 0.5)

// Notifications
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataChanged")
let NOTIF_CHANNELS_LOADED = Notification.Name("notifChannelsLoaded")
let NOTIF_CHANNEL_SELECTED = Notification.Name("notifChannelSelected")
