//
//  FriendModel.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/24/23.
//

import Foundation
import SwiftVRChatAPI

struct Friend: Identifiable {
    let id = UUID()
    
    let user: User
    let world: World?
    let instance: Instance?
    
    init(user: User, world: World? = nil, instance: Instance? = nil) {
        self.user = user
        self.world = world
        self.instance = instance
    }
}
