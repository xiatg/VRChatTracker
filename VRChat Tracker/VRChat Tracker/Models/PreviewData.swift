//
//  PreviewData.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/23/23.
//

import Foundation


let userPreview = """
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

let worldExample = VRWorld(name: "The Black Cat", id: "wrld_4cf554b4-430c-4f8f-b53e-1f294eed230b", authorName: "spookyghostboo", imageUrl: "https://api.vrchat.cloud/api/1/file/file_ab2d3af4-c6da-41b9-8a3d-6f554462cfaf/21/file", description: "The Black Cat is a simple mirror world․ Come hangout‚ meet new friends‚ eat pancakes‚ and stare at yourself․", authorId: "usr_3d10ca69-6586-40a3-aa1b-a0c9e38a0d20", favorites: 217516, visits: 52712533, capacity: 18, created_at: "2019-05-01T01:19:43.477Z", updated_at: "2022-10-02T15:45:39.289Z")

let worldExample2 = VRWorld(name: "LS Media", id: "wrld_1b68f7a8-8aea-4900-b7a2-3fc4139ac817", authorName: "LoliGoddess", imageUrl: "https://api.vrchat.cloud/api/1/file/file_7b9a68b0-13ea-4d27-bdfc-71a20ee49a41/15/file", description: "Biggest Movie‚ TV Show and Anime watching world with a powerful yet simple and uncluttered media library․ Watch your favorite animes while playing fun games or fall asleep ＂cuddling＂ while watching a movie․ join our group˸ https˸⁄⁄vrc․group⁄LSM․4768", authorId: "usr_7c32060e-d029-43dd-b8a1-3533992e9b91", favorites: 243661, visits: 11271416, capacity: 40, created_at: "2021-10-09T21:01:42.353Z", updated_at: "2022-10-27T00:50:07.341Z")

let worldExample3 = VRWorld(name: "The room of the rain", id: "wrld_fae3fa95-bc18-46f0-af57-f0c97c0ca90a", authorName: "Ivaj15", imageUrl: "https://api.vrchat.cloud/api/1/file/file_e4041df4-ecab-4494-86d6-7debe18ab8b3/5/file", description: "in this place it always rains․ Now with pool table‚ sleep mode‚ fire place‚ an ocean‚ news‚ pencils‚ beer pong‚ mirror light and a new mirror in bedǃ made by Ivaj （ spanish hub）․", authorId: "usr_6cc30b65-edf2-4e49-ac50-d56aa533d822", favorites: 154522, visits: 29272808, capacity: 24, created_at: "2019-03-12T02:43:02.384Z", updated_at: "2022-10-13T00:40:35.490Z")
