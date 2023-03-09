//
//  WorldModel.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import Foundation
import SwiftVRChatAPI

//struct World: Codable, Identifiable {
struct VRWorld : Identifiable{
    let name: String?
    let id: String?
    let authorName: String?
    let imageUrl: String?
    let description: String?
    let authorId: String?
    let favorites: Int?
    let visits: Int?
    let capacity: Int?
    let created_at: String?
    let updated_at: String?
}
