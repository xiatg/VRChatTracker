//
//  PreviewData.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/23/23.
//

import Foundation
import SwiftVRChatAPI

class PreviewData {
    
    static func load<T: Codable>(name: String) -> T? {
        if let path = Bundle.main.path(forResource: name, ofType: ".json") {
            do {
                let data = try Data(contentsOf: URL(filePath: path))
                let result = try JSONDecoder().decode(T.self, from: data)
                return result
            } catch {
                
            }
        }
        
        return nil
    }
}

let worldExample = VRWorld(name: "The Black Cat", id: "wrld_4cf554b4-430c-4f8f-b53e-1f294eed230b", authorName: "spookyghostboo", imageUrl: "https://api.vrchat.cloud/api/1/file/file_ab2d3af4-c6da-41b9-8a3d-6f554462cfaf/21/file", description: "The Black Cat is a simple mirror world․ Come hangout‚ meet new friends‚ eat pancakes‚ and stare at yourself․", authorId: "usr_3d10ca69-6586-40a3-aa1b-a0c9e38a0d20", favorites: 217516, visits: 52712533, capacity: 18, created_at: "2019-05-01T01:19:43.477Z", updated_at: "2022-10-02T15:45:39.289Z")

let worldExample2 = VRWorld(name: "LS Media", id: "wrld_1b68f7a8-8aea-4900-b7a2-3fc4139ac817", authorName: "LoliGoddess", imageUrl: "https://api.vrchat.cloud/api/1/file/file_7b9a68b0-13ea-4d27-bdfc-71a20ee49a41/15/file", description: "Biggest Movie‚ TV Show and Anime watching world with a powerful yet simple and uncluttered media library․ Watch your favorite animes while playing fun games or fall asleep ＂cuddling＂ while watching a movie․ join our group˸ https˸⁄⁄vrc․group⁄LSM․4768", authorId: "usr_7c32060e-d029-43dd-b8a1-3533992e9b91", favorites: 243661, visits: 11271416, capacity: 40, created_at: "2021-10-09T21:01:42.353Z", updated_at: "2022-10-27T00:50:07.341Z")

let worldExample3 = VRWorld(name: "The room of the rain", id: "wrld_fae3fa95-bc18-46f0-af57-f0c97c0ca90a", authorName: "Ivaj15", imageUrl: "https://api.vrchat.cloud/api/1/file/file_e4041df4-ecab-4494-86d6-7debe18ab8b3/5/file", description: "in this place it always rains․ Now with pool table‚ sleep mode‚ fire place‚ an ocean‚ news‚ pencils‚ beer pong‚ mirror light and a new mirror in bedǃ made by Ivaj （ spanish hub）․", authorId: "usr_6cc30b65-edf2-4e49-ac50-d56aa533d822", favorites: 154522, visits: 29272808, capacity: 24, created_at: "2019-03-12T02:43:02.384Z", updated_at: "2022-10-13T00:40:35.490Z")

let avatarExample1 = Avatar(name: "BB Red Dead of Night", id: "avtr_ca2ff732-f5ed-4c64-a2a2-272efaa051c5", authorName: "-CoconutMilku-", imageUrl: "https://api.vrchat.cloud/api/1/file/file_a21a0455-9919-495f-8148-1d05705c70ef/1/file", description: "BB Red Dead of Night", authorId: "usr_0cc0d7af-9df7-4ddc-8da4-c1e98d3a5818", updated_at: "2022-08-04T20:27:31.509Z")

let avatarExample2 = Avatar(name: "Neko Caboose Hot Pink n Wings", id: "avtr_e8393e34-d5a8-4cfe-bf47-781dfa1bfaa8", authorName: "g6qwerty", imageUrl: "https://api.vrchat.cloud/api/1/file/file_1d51364a-c645-4854-9c47-12af9252d2d7/1/file", description: "Neko Caboose Hot Pink V8․3․2 quest （FBT", authorId: "usr_80bc9da2-3607-4a2c-80ec-c7e5fef80671", updated_at: "2021-06-16T22:08:48.025Z")

let avatarExample3 = Avatar(name: "boccragdoll", id: "avtr_8aa138a2-77f3-4a29-b60e-147774127121", authorName: "Brooke", imageUrl: "https://api.vrchat.cloud/api/1/file/file_791b2375-d88f-49aa-b10a-f2e2e3ad12bd/4/file", description: "boccragdoll", authorId: "usr_25e26b23-c0fa-42a9-a914-155ca307affe", updated_at: "2023-01-29T00:05:13.735Z")
