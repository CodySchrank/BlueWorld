//
//  Network.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation

public class Network {
    static let
        SENBaseURL = "https://auth.api.sonyentertainmentnetwork.com",
        redirectURL_oauth = "com.scee.psxandroid.scecompcall://redirect",
        client_id = "b0d0d7ad-bb99-4ab1-b25e-afa0c76577b0",
        scope = "sceapp",
        scope_psn = "psn:sceapp,user:account.get,user:account.settings.privacy.get,user:account.settings.privacy.update,user:account.realName.get,user:account.realName.update,kamaji:get_account_hash",
        csrfToken = "",
        authCode = "",
        client_secret = "Zo4y8eGIa3oazIEp",
        duid = "00000005006401283335353338373035333434333134313a433635303220202020202020202020202020202020",
        state = "1156936032",
        service_entity = "urn:service-entity:psn",
        paramString = "c2VydmljZV9lbnRpdHk9cHNuJnJlcXVlc3RfdGhlbWU9bGlxdWlk",
        userAgent = "Mozilla/5.0 (Linux; U; Android 4.3; \(Options.npLanguage); C6502 Build/10.4.1.B.0.101) AppleWebKit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30 PlayStation App/2.55.8/\(Options.npLanguage)/\(Options.npLanguage)",
        requestedWith = "com.scee.psxandroid"
    
    static var PSNHeaders = [
//        "Access-Control-Request-Method": "GET",
        "Origin": "http://psapp.dl.playstation.net",
        "Access-Control-Request-Headers": "Origin, Accept-Language, Authorization, Content-Type, Cache-Control",
        "Accept-Language": Options.npLanguage,
        "Authorization": "Bearer \(User.access_token)",
        "Cache-Control": "no-cache",
        "X-Requested-With": "\(Network.requestedWith)",
        "User-Agent": "\(Network.userAgent)"
    ]
}