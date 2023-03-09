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
    @Environment(\.scenePhase) private var phase
    
    @StateObject var client = VRChatClient()
    
    var body: some Scene {
        
        // check if the user is already logged in
        // yes: navigation view
        // no: login page view
        WindowGroup {
            if (client.isLoggedIn) {
                NavigationView(client: client)
            } else if (!client.isAutoLoggingIn) {
                LoginView(client: client)
            }
        }
    }
}
