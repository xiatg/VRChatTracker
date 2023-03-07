//
//  AvatarModel.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 3/3/23.
//

import Foundation
import SwiftVRChatAPI

struct VRAvatar : Identifiable{
    let name: String?
    let id: String?
    let authorName: String?
    let imageUrl: String?
    let description: String?
    let authorId: String?
    let updated_at: String?
}
