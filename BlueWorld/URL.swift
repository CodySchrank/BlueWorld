//
//  URL.swift
//  BlueWorld
//
//  Created by Cody Schrank on 12/2/15.
//  Copyright © 2015 TheTapAttack. All rights reserved.
//

import Foundation

/**
* EVERYTHING BUT SIGN IN, AUTH, AND LOGOUT HAVE TO BE PREPPED TO USE!
**/

public class URL {
    static let
        SignIN = "\(Network.SENBaseURL)/2.0/oauth/authorize?response_type=code&service_entity=\(Network.service_entity)&returnAuthCode=true&state=\(Network.state)&redirect_uri=\(Network.redirectURL_oauth)&client_id=\(Network.client_id)&scope=\(Network.scope_psn)",
        SignINPOST = "\(Network.SENBaseURL)/login.do",
        oauth = "https://auth.api.sonyentertainmentnetwork.com/2.0/oauth/token",
        profileData = "https://{{region}}-prof.np.community.playstation.net/userProfile/v1/users/{{id}}/profile?fields=%40default,relation,requestMessageFlag,presence,%40personalDetail,trophySummary",
        friendData = "https://{{region}}-prof.np.community.playstation.net/userProfile/v1/users/me/friends/profiles2?fields=onlineId%2CavatarUrls%2Cplus%2CtrophySummary(%40default)%2CisOfficiallyVerified%2CpersonalDetail(%40default%2CprofilePictureUrls)%2CprimaryOnlineStatus%2Cpresences(%40titleInfo%2ChasBroadcastData)&sort=name-onlineId&avatarSizes=m&profilePictureSizes=m&offset={{offset}}&npLanguage={{lang}}",
        trophyData = "https://{{region}}-tpy.np.community.playstation.net/trophy/v1/trophyTitles?fields=%40default&npLanguage={{lang}}&platform=PS4%2CPSVITA%2CPS4&offset={{offset}}&limit={{limit}}",
        allTrophyData = "https://{{region}}-tpy.np.community.playstation.net/trophy/v1/trophyTitles?fields=%40default&npLanguage={{lang}}&platform=PS4%2CPSVITA%2CPS4&offset={{offset}}",
    //    trophyDataList = 'https://{{region}}-tpy.np.community.playstation.net/trophy/v1/trophyTitles/{{npCommunicationId}}/trophyGroups/{{groupId}}/trophies?fields=%40default,trophyRare,trophyEarnedRate&npLanguage={{lang}}'
        trophyGroupList = "https://{{region}}-tpy.np.community.playstation.net/trophy/v1/trophyTitles/{{npCommunicationId}}/trophyGroups/all/trophies?fields=@default,trophyRare,trophyEarnedRate&npLanguage={{lang}}&iconSize=m",
    //    ,trophyInfo:	'https://{{region}}-tpy.np.community.playstation.net/trophy/v1/trophyTitles/{{npCommunicationId}}/trophyGroups/{{groupId}}/trophies/{{trophyID}}?fields=%40default,trophyRare,trophyEarnedRate&npLanguage={{lang}}'
        messageGroup = "https://{{region}}-gmsg.np.community.playstation.net/groupMessaging/v1/users/{{id}}/messageGroups?fields=@default%2CmessageGroupId%2CmessageGroupDetail%2CtotalUnseenMessages%2CtotalMessages%2ClatestMessage&npLanguage={{lang}}",
        messageConversation = "https://{{region}}-gmsg.np.community.playstation.net/groupMessaging/v1/messageGroups/{{id}}/messages?fields=@default%2CmessageGroup%2Cbody&npLanguage={{lang}}",
        messagePost = "https://{{region}}-gmsg.np.community.playstation.net/groupMessaging/v1/messageGroups/{{id}}/messages",
        messageSeenFlag = "https://{{region}}-gmsg.np.community.playstation.net/groupMessaging/v1/messageGroups/{{messageGroupId}}/messages?messageUid={{messageUid}}",
        logout = "https://io.playstation.com/playstation/psn/logout?postSignOutURL=https://www.playstation.com/en-us/",
        me = "https://vl.api.np.km.playstation.net/vl/api/v1/mobile/users/me/info",
        recentActivity = "https://activity.api.np.km.playstation.net/activity/api/v1/users/{0}/{1}/{2}?filters=PLAYED_GAME&filters=TROPHY&filters=BROADCASTING&filters=PROFILE_PIC&filters=FRIENDED",
        activityFeed = "https://activity.api.np.km.playstation.net/activity/api/v1/users/{{user}}/feed/{{offset}}?includeComments=true&filters=PURCHASED&filters=RATED&filters=VIDEO_UPLOAD&filters=SCREENSHOT_UPLOAD&filters=PLAYED_GAME&filters=WATCHED_VIDEO&filters=TROPHY&filters=BROADCASTING&filters=LIKED&filters=PROFILE_PIC&filters=FRIENDED&filters=CONTENT_SHARE&filters=IN_GAME_POST&filters=RENTED&filters=SUBSCRIBED&filters=FIRST_PLAYED_GAME&filters=IN_APP_POST&filters=APP_WATCHED_VIDEO&filters=SHARE_PLAYED_GAME&filters=VIDEO_UPLOAD_VERIFIED&filters=SCREENSHOT_UPLOAD_VERIFIED&filters=SHARED_EVENT&filters=JOIN_EVENT&filters=TROPHY_UPLOAD&filters=FOLLOWING",
        allTrophyCompare = "https://{{region}}-tpy.np.community.playstation.net/trophy/v1/trophyTitles?fields=%40default&npLanguage={{lang}}&iconSize=m&platform=PS3%2CPSVITA%2CPS4&offset=0&comparedUser={{user}}"
    
    static func prepURL(url: String,options: [String:String]?,region: String?,lang: String?) -> String {
        if let region = region, lang = lang {
            let preppedString = url.stringByReplacingOccurrencesOfString("{{region}}", withString: region).stringByReplacingOccurrencesOfString("{{lang}}", withString: lang)
            
            if let options = options {
                var properString = preppedString
                for (key,value) in options {
                    properString = properString.stringByReplacingOccurrencesOfString(key, withString: value)
                }
                return properString
            }
            
            return preppedString
        } else {
            let preppedString = url.stringByReplacingOccurrencesOfString("{{region}}", withString: Options.region).stringByReplacingOccurrencesOfString("{{lang}}", withString: Options.npLanguage)
            
            if let options = options {
                var properString = preppedString
                for (key,value) in options {
                    properString = properString.stringByReplacingOccurrencesOfString(key, withString: value)
                }
                return properString
            }
            
            return preppedString
        }
    }
}
