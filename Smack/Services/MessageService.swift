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
    
    func findAllChannels(completion: @escaping CompletionHandler) {
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
                completion(true)
            } else {
               completion(false)
               debugPrint(response.result.error as Any)
            }
        }
    }
}
