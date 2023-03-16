//
//  VRChat_TrackerApp.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/16/23.
//

import SwiftUI

@main
struct VRChat_TrackerApp: App {
    @StateObject var client = VRChatClient()
    
    var body: some Scene {
        
        // check if the user is already logged in
        // yes: navigation view
        // no: login page view
        WindowGroup {
            if (client.isLoggedIn) {
                NavigationView(client: client)
            } else {
                LoginView(client: client)
            }
        }
    }
}
