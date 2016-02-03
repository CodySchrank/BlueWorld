//
//  AuthManager.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation
import SwiftHTTP
import CoreData

class AuthManager {

    init(email: String?,password: String?) {
        if let email = email,
        password = password {
            User.email = email
            User.password = password
        }
    }
    
    let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    func GetCredentials(callback: () -> Void) {
        Config.debug("Starting Auth")
        
        /** Ghetto trick to make sure the response isn't cached **/
        self.logout() {
            do {
                
                let parameters = [
                    "params" : "\(Network.paramString)",
                    "j_username" : User.email,
                    "j_password" : User.password
                ]
                
                let headers = [
                    "User-Agent" : "\(Network.userAgent)",
                    "X-Requested-With": Network.requestedWith,
                    "Origin" : Network.SENBaseURL,
                    "Referer": URL.SignIN
                ]
                
                let opt = try HTTP.POST(URL.SignINPOST, parameters: parameters, headers: headers)
                
                opt.start() {
                    response in
                    
                    if((response.error) != nil) {
                        Config.debug(response.error!)
                    } else {
                        self.LogIn(callback)
                    }
                }
            } catch let e {
                print(e)
                //                NSNotificationCenter.defaultCenter().postNotificationName(Tools.ErrorNotification,object:nil,userInfo:["message": e])
            }
        }
    }
    
    private func LogIn(callback: () -> Void) {
        do {
            Config.debug("Logging In")
            let headers = [
                "User-Agent" : "\(Network.userAgent)",
                "X-Requested-With": Network.requestedWith,
                "Origin" : Network.SENBaseURL,
                "Referer": URL.SignIN
            ]
            
            let opt = try HTTP.GET(URL.SignIN,headers: headers)
            
            opt.start() {
                response in
                
                if((response.error) != nil) {
                    Config.debug(response.error!)
                } else {
                    Config.debug("Logged In")
                    
                    let urlQuery = response.URL!.query!
                    let myRegex = "code%3D"
                    
                    if let match = urlQuery.rangeOfString(myRegex, options: .RegularExpressionSearch){
                        let rangeIndex = urlQuery.startIndex.distanceTo(match.endIndex)
                        let code = urlQuery.substringWithRange(rangeIndex, end: rangeIndex + 6)
                        self.GetAccessToken(code,callback: callback)
                    } else {
                        Config.debug("Invalid Login")
                        callback()
                    }
                    
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    private func GetInformation(callback: () -> Void) {
        do {
            Config.debug("Getting Information")
            
            let headers = Network.PSNHeaders
            
            let opt = try HTTP.GET(URL.me,headers: headers)
            
            opt.start() {
                response in
                
                if((response.error) != nil) {
                    Config.debug(response.error!)
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingOptions.AllowFragments)
                        
                        /**
                        
                            This json contains various information about the user.
                            For now it is only being used for the username, but we 
                            could store all of this in the User object

                        **/
                        
                        guard let username = json["onlineId"] where (username as? String) != nil else {
                            return Config.debug("The Auth failed.  No Online ID present.  Try logging in again")
                        }
                        
                        User.username = json["onlineId"] as! String
                        
                        Config.debug("Welcome \(User.username)")
                        
                        callback()
                        
                    } catch let e {
                        print(e)
                    }
                    
                }
            }
        } catch let e {
            print(e)
        }
    }
    
    private func GetAccessToken(authCode: String,callback: () -> Void) {
        do {
            Config.debug("Getting Access Token")

            let parameters = [
                "grant_type" : "authorization_code",
                "client_id"	: "\(Network.client_id)",
                "client_secret": "\(Network.client_secret)",
                "code" 		: "\(authCode)",
                "redirect_uri" : "\(Network.redirectURL_oauth)",
                "state" : "x",
                "scope"	: "\(Network.scope_psn)",
                "duid" : "\(Network.duid)"
            ]
            
            let opt = try HTTP.POST(URL.oauth, parameters: parameters)
            
            opt.start() {
                response in
                
                if((response.error) != nil) {
                    Config.debug(response.error!)
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingOptions.AllowFragments)

                        guard let accessToken = json["access_token"] where (accessToken as? String) != nil else {
                            Config.debug("No Access Token")
                            return
                        }
                        guard let refreshToken = json["refresh_token"] where (refreshToken as? String) != nil else {
                            Config.debug("No Refresh Token")
                            return
                        }
                        
                        User.access_token = accessToken as! String
                        User.refresh_token = refreshToken as! String
                        
                        let time = NSDate()
                        User.access_token_timestap = time
                        
                        Config.debug("Received access token")
                        
                        self.GetInformation(callback)
                    } catch let error {
                       print(error)
                    }
                }
            }
        } catch let error {
            print(error)
        }
    }
    
    static func GetNewAccessToken(refreshToken: String,callback: () -> Void) {
        do {
            Config.debug("Getting New Access Token")
            
            let parameters = [
                "grant_type" : "refresh_token",
                "client_id"	: "\(Network.client_id)",
                "client_secret": "\(Network.client_secret)",
                "refresh_token" : "\(refreshToken)",
                "redirect_uri" : "\(Network.redirectURL_oauth)",
                "state" : "x",
                "scope"	: "\(Network.scope_psn)",
                "duid" : "\(Network.duid)"
            ]
            
            let opt = try HTTP.POST(URL.oauth, parameters: parameters)
            
            opt.start() {
                response in
                
                if((response.error) != nil) {
                    Config.debug(response.error!)
                } else {
                    do {
                        let json = try NSJSONSerialization.JSONObjectWithData(response.data, options: NSJSONReadingOptions.AllowFragments)
                        
                        guard let accessToken = json["access_token"] where (accessToken as? String) != nil else {
                            Config.debug("No Access Token")
                            return
                        }
                        guard let refreshToken = json["refresh_token"] where (refreshToken as? String) != nil else {
                            Config.debug("No Refresh Token")
                            return
                        }
                        
                        User.access_token = accessToken as! String
                        User.refresh_token = refreshToken as! String
                        
                        let time = NSDate()
                        User.access_token_timestap = time
                        
                        Config.debug("Received new access token")
                        
                        callback()
                    } catch let error {
                        print(error)
                    }
                }
            }
        } catch let error {
            print(error)
        }

    }
    
    func logout(callback: (() -> Void)!) {
        if callback != nil {
            do {
                Config.debug("Checking to see if logged in")
                let headers = [
                    "User-Agent" : "\(Network.userAgent)",
                    "X-Requested-With": Network.requestedWith,
                    "Origin" : Network.SENBaseURL
                ]
                
                let opt = try HTTP.GET(URL.logout,headers: headers)
                
                opt.start() {
                    response in
                    callback()
                }
            } catch let error {
                print(error)
            }
        } else {
            do {
                Config.debug("Logging Out")
                let headers = [
                    "User-Agent" : "\(Network.userAgent)",
                    "X-Requested-With": Network.requestedWith,
                    "Origin" : Network.SENBaseURL,
                    "Referer": URL.SignIN
                ]
                
                let opt = try HTTP.GET(URL.logout,headers: headers)
                
                opt.start() {
                    response in
                    Config.debug("Logged Out")
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    static func getReqWithAuth(callback: () -> Void) {
        let currentTime = NSDate()
        if let timestamp = User.access_token_timestap {
            let diff = currentTime.timeIntervalSinceDate(timestamp)
            
            if diff > 7200 {
                let auth = AuthManager(email: nil, password: nil)
                auth.GetCredentials() {
                    callback()
                }
            } else if diff > 3600 {
                //Need new credentials
                AuthManager.GetNewAccessToken(User.refresh_token) {
                    callback()
                }
            } else {
                callback()
            }
            
        } else {
            Config.debug("Fatal error: No credentials.  Get Initial credentials")
        }
    }
}


