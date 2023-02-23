//
//  VRChatClient.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import Foundation
import SwiftVRChatAPI

class VRChatClient: ObservableObject {
    
    @Published var isLoggedIn = false
    @Published var is2FA = false
    
    @Published var userInfo: AuthenticationAPI.UserInfo?
    
    var apiClient:APIClient?
    
    init() {
        apiClient = APIClient()
        apiClient!.updateCookies()
        
        print(apiClient?.cookies)
        
        userInfo = AuthenticationAPI(client: apiClient!).loginUserInfo()
        
        if (userInfo?.displayName != nil) {
            isLoggedIn = true
        }
    }
    
    static func createPreview() -> VRChatClient {
        var client_preview = VRChatClient()
        
        let json = """
{
    "id": "usr_e07a748a-acf7-46a3-886a-18447e9126d3",
    "displayName": "Natsuki关注永雏塔菲喵",
    "userIcon": "",
    "bio": "Move to another VRC account˸ 夏同光Natsuki",
    "bioLinks": [],
    "profilePicOverride": "",
    "statusDescription": "",
    "username": "sunny915915",
    "pastDisplayNames": [
        {
            "displayName": "sunny915915",
            "updated_at": "2022-03-15T14:05:56.473Z",
            "reverted": false
        }
    ],
    "hasEmail": true,
    "hasPendingEmail": false,
    "obfuscatedEmail": "i******@gmail.com",
    "obfuscatedPendingEmail": "",
    "emailVerified": true,
    "hasBirthday": true,
    "unsubscribe": false,
    "statusHistory": [
        "Looking to make new friends",
        "Ask me about ․․․",
        "Let's partyǃ",
        "I'm AFK right now",
        "I'm streaming on Twitch",
        "My mic is muted",
        "I'm here but busy",
        "I speak ［English］",
        "I create ․․․",
        "My discord is ․․․‚"
    ],
    "statusFirstTime": true,
    "friends": [
        "usr_65db9687-8694-4801-86f4-d0ba575099ab",
        "usr_d99464e5-15a7-40d1-93e8-3924172add77",
        "usr_2b65ae65-f5d8-452e-b1a0-79ccbece3312",
        "usr_3c65921c-75a2-4b9c-a40e-18bbb53d53b1",
        "usr_0e5fed53-48ac-4cd8-af2f-3a00c7c1928a",
        "usr_4356aef0-fa41-4858-a613-9d3b6ad2a0f5"
    ],
    "friendGroupNames": [],
    "currentAvatarImageUrl": "https://api.vrchat.cloud/api/1/file/file_ea36dd11-163e-4511-979a-8ed1f01f3793/1/file",
    "currentAvatarThumbnailImageUrl": "https://api.vrchat.cloud/api/1/image/file_ea36dd11-163e-4511-979a-8ed1f01f3793/1/256",
    "currentAvatar": "avtr_9406167f-1825-451f-a529-305190ab05fc",
    "currentAvatarAssetUrl": "https://api.vrchat.cloud/api/1/file/file_59d215bf-e4e5-4796-85ba-ad0f6f271f60/1/file",
    "fallbackAvatar": "avtr_25e47ba5-a589-49e0-afda-ee6049eb3a5c",
    "accountDeletionDate": null,
    "accountDeletionLog": null,
    "acceptedTOSVersion": 8,
    "steamId": "76561198180342437",
    "steamDetails": {
        "avatar": "https://avatars.akamai.steamstatic.com/4c2150d92ac9224c4bed746ee2b1900de522665f.jpg",
        "avatarfull": "https://avatars.akamai.steamstatic.com/4c2150d92ac9224c4bed746ee2b1900de522665f_full.jpg",
        "avatarhash": "4c2150d92ac9224c4bed746ee2b1900de522665f",
        "avatarmedium": "https://avatars.akamai.steamstatic.com/4c2150d92ac9224c4bed746ee2b1900de522665f_medium.jpg",
        "commentpermission": 1,
        "communityvisibilitystate": 3,
        "gameextrainfo": "VRChat",
        "gameid": "438100",
        "loccountrycode": "KP",
        "personaname": "Natsuki",
        "personastate": 1,
        "personastateflags": 0,
        "primaryclanid": "103582791439339235",
        "profilestate": 1,
        "profileurl": "https://steamcommunity.com/id/WatanabeXia/",
        "realname": "夏同光",
        "steamid": "76561198180342437",
        "timecreated": 1424341965
    },
    "oculusId": "",
    "hasLoggedInFromClient": false,
    "homeLocation": "wrld_3448f7e4-79a7-4115-a44c-e6221174969f",
    "twoFactorAuthEnabled": false,
    "twoFactorAuthEnabledDate": null,
    "updated_at": "2023-01-26T02:27:18.572Z",
    "state": "offline",
    "tags": [
        "system_no_captcha",
        "language_eng",
        "language_jpn"
    ],
    "developerType": "none",
    "last_login": "2023-02-23T02:16:15.680Z",
    "last_platform": "standalonewindows",
    "allowAvatarCopying": true,
    "status": "busy",
    "date_joined": "2022-03-15",
    "isFriend": false,
    "friendKey": "ebbfb24fffc8e74d3eb02738193b0cdb",
    "last_activity": "2022-12-26T02:06:52.412Z",
    "onlineFriends": [],
    "activeFriends": [],
    "presence": {
        "id": "usr_e07a748a-acf7-46a3-886a-18447e9126d3",
        "platform": "",
        "status": "offline",
        "world": "offline",
        "instance": "offline",
        "instanceType": "",
        "travelingToWorld": "offline",
        "travelingToInstance": "offline",
        "groups": []
    },
    "offlineFriends": [
        "usr_65db9687-8694-4801-86f4-d0ba575099ab",
        "usr_d99464e5-15a7-40d1-93e8-3924172add77",
        "usr_2b65ae65-f5d8-452e-b1a0-79ccbece3312",
        "usr_3c65921c-75a2-4b9c-a40e-18bbb53d53b1",
        "usr_0e5fed53-48ac-4cd8-af2f-3a00c7c1928a",
        "usr_4356aef0-fa41-4858-a613-9d3b6ad2a0f5"
    ]
}
"""
        
        client_preview.userInfo = try! JSONDecoder().decode(AuthenticationAPI.UserInfo.self, from: json.data(using: .utf8)!)
        
        return client_preview
    }
}
