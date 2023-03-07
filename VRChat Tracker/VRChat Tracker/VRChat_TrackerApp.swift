//
//  VRChat_TrackerApp.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/16/23.
//

import SwiftUI
import SwiftVRChatAPI

@main
struct VRChat_TrackerApp: App {
    @StateObject var client = VRChatClient()
    
    init() {
        registration()
    }
    
    var body: some Scene {
        WindowGroup {
            if (client.isLoggedIn) {
                NavigationView(client: client)
            } else {
                LoginView(client: client)
            }
        }
    }
    
    func registration() {
        
    }
}
