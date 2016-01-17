//
//  MessagesManager.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import SwiftHTTP

class MessagesManager {
    func getMessageGroup(firstTime: Bool,callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting message information for: \(User.username)")
            
            let url = URL.prepURL(URL.messageGroup,options: ["{{id}}": User.username] ,region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    if((response.error) != nil) {
                        Config.debug(response.error!)
                    } else {
                        let data = Tools.parseAnyJSON(response.data)
                        if let data = data?["messageGroups"] as? [[String: AnyObject]] {
                            MessageGroup.parseJSONForMessageGroup(firstTime,data: data)
                        }
                        callback()
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func getMessageConversation(id: String,callback: ([[String: AnyObject]]) -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Getting \(id) conversation")
            
            let url = URL.prepURL(URL.messageConversation,options: ["{{id}}": id] ,region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.GET(url, headers: headers)
                
                opt.start() {
                    response in
                    
                    if((response.error) != nil) {
                        Config.debug(response.error!)
                    } else {
                        let data = Tools.parseAnyJSON(response.data)
                        if let data = data?["messages"] as? [[String: AnyObject]] {
                            callback(data)
                        }
                    }
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func sendMessage(id: String, postData: [String: AnyObject], callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            let url = URL.prepURL(URL.messagePost, options: ["{{id}}":id], region: nil, lang: nil)
        
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "POST"
            
            request.setValue("Bearer \(User.access_token)", forHTTPHeaderField: "Authorization")
            
            let boundary = "gc0p4Jq0M2Yt08jU534c0p"
            let contentType = "multipart/mixed; boundary=\"\(boundary)\""
            request.setValue(contentType, forHTTPHeaderField: "Content-Type")
            
            let body = NSMutableData()
            
            var bodyData = "\n"
            bodyData += "--\(boundary)\n"
            bodyData += "Content-Type: application/json; charset=utf-8\n"
            bodyData += "Content-Description: message\n\n"
            bodyData += "{\n  \"message\" : {\n"
            for (key,value) in postData {
                if value is String {
                    bodyData += "    \"\(key)\" : \"\(value)\",\n"
                } else {
                    bodyData += "    \"\(key)\" : \(String(stringInterpolationSegment: value)),\n"
                }
            }
            bodyData.removeAtIndex(bodyData.endIndex.advancedBy(-1))
            bodyData.removeAtIndex(bodyData.endIndex.advancedBy(-1))
            bodyData += "\n }\n}\n"
            bodyData += "--\(boundary)--\n\n"
            
            body.appendData(bodyData.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)

            request.HTTPBody = body

            let session = NSURLSession.sharedSession()
        
            let req = session.dataTaskWithRequest(request) {
                data, res, err in
                callback()
                if let data = data {
                    let json = Tools.parseJSON(data)
                    if let messageGroupId = json?["messageGroupId"] as? String,
                        messageUid = json?["messageUid"] as? Int {
                        let messageManager = MessagesManager()
                        messageManager.seenFlag(messageGroupId, messageUid: String(stringInterpolationSegment: messageUid)) {
                            
                        }
                    }
                }
            }
            
            req.resume()
        }
    }
    
    func seenFlag(messageGroupId: String, messageUid: String, callback: () -> Void) {
        AuthManager.getReqWithAuth() {
            Config.debug("Sending Seen Flag")
            
            let url = URL.prepURL(URL.messageSeenFlag,options: ["{{messageGroupId}}": messageGroupId, "{{messageUid}}": messageUid] ,region: nil, lang: nil)
            
            do {
                let headers = Network.PSNHeaders
                
                let opt = try HTTP.New(url, method: .PUT, parameters: ["seenFlag": true], headers: headers, requestSerializer: JSONParameterSerializer())
                
                opt.start() {
                    response in

                }
            } catch let error {
                print(error)
            }
        }
    }
}