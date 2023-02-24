//
//  WorldModel.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import Foundation

//struct VRWorld: Codable, Identifiable {
struct VRWorld : Identifiable{
    let name: String?
    let id: String?
    let authorName: String?
    let imageUrl: String?
    let description: String?
    let authorId: String?
    let favorites: Double?
    let visits: Double?
    let capacity: Double?
    let created_at: String?
    let updated_at: String?
}
