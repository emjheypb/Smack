//
//  MessageService.swift
//  Smack
//
//  Created by Mariah Baysic on 4/13/20.
//  Copyright © 2020 SpacedOut. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    static let instance = MessageService() // Singleton
    
    var channels = [Channel]()
    var messages = [Message]()
    var selectedChannel : Channel?
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        channels = [Channel]()
        
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
//                do {
//                    self.channels = try JSONDecoder().decode([Channel].self, from: data)
//                } catch let error {
//                    debugPrint(error as Any)
//                }
                
                if let json = JSON(data).array {
                    for item in json {
                        let name = item["name"].stringValue
                        let description = item["description"].stringValue
                        let id = item["_id"].stringValue
                        let channel = Channel(id: id, name: name, description: description)

                        self.channels.append(channel)
                    }
                }
//                print(self.channels)
                NotificationCenter.default.post(name: NOTIF_CHANNELS_LOADED, object: nil)
                completion(true)
            } else {
                debugPrint(response.result.error as Any)
               completion(false)
            }
        }
    }
    
    func getAllChannelMessages(completion: @escaping CompletionHandler) {
        clearMessages()
        
        Alamofire.request(URL_GET_MESSAGES + selectedChannel!.id, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                if let json = JSON(data).array {
                    for item in json {
                        let id = item["_id"].stringValue
                        let messageBody = item["messageBody"].stringValue
                        let channelID = item["channelId"].stringValue
                        let userName = item["userName"].stringValue
                        let userAvatar = item["userAvatar"].stringValue
                        let userAvatarColor = item["userAvatarColor"].stringValue
                        let timestamp = item["timeStamp"].stringValue
                        
                        let message = Message(id: id, message: messageBody, channelID: channelID, userName: userName, userAvatar: userAvatar, userAvatarColor: userAvatarColor, timeStamp: timestamp)
                        
                        self.messages.append(message)
                    }
                }
                
                completion(true)
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
    
    func clearChannels() {
        channels.removeAll()
        selectedChannel = nil
    }
    
//    func createChannel(name: String, description: String, completion: @escaping CompletionHandler) {
//        
//        let body = [
//            "name" : name,
//            "description" : description
//        ]
//        
//        Alamofire.request(URL_CREATE_CHANNEL, method: .post, parameters: body, encoding: JSONEncoding.default, headers: BEARER_HEADER).responseJSON { (response) in
//            if response.result.error == nil {
//                completion(true)
//            }  else {
//              completion(false)
//              debugPrint(response.result.error as Any)
//           }
//        }
//    }
}
