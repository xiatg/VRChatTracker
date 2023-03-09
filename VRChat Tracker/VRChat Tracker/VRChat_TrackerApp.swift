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
    
    let defaults = UserDefaults.standard
    
    @State private var showRating = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            
            if (showSplash) {
                SplashView()
                    .onTapGesture {
                        showSplash = false
                    }
                    .onAppear() {
                        registration()
                    }
                    .alert(isPresented: self.$showRating) {
                        Alert(title: Text("Rate this App in the App Store!"),
                              message: Text("Please? 🥺"),
                              dismissButton: .default(Text("Okay")))
                    }
            } else if (client.isLoggedIn) {
                NavigationView(client: client)
            } else {
                LoginView(client: client)
            }
        }
    }
    
    func registration() {
        defaults.register(defaults: ["openTime": 0])
        
        var openTime = defaults.integer(forKey: "openTime")
        openTime += 1
        defaults.set(openTime, forKey: "openTime")
        
        //Debug
        print("open time: \(openTime)")
        
        if (openTime == 3) {
            self.showRating = true
            
            print("show rating!! \(self.showRating)")
        }
        
    }
}
