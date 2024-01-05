//
//  NavigationView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/19/23.
//

import SwiftUI

struct NavigationView: View {
    @ObservedObject var client: VRChatClient
    
    @State private var selection = 3
    
    var body: some View {
        TabView(selection: $selection) {
            // 1. the view shows all the worlds
            WorldTabView(client: client)
                .tabItem {
                    Image(systemName: "globe")
                    Text("Worlds")
                }
                .tag(1)
            // 2. the view shows all the avatars
            AvatarTabView(client: client)
                .tabItem {
                    Image(systemName: "theatermasks")
                    Text("Avatars")
                }
                .tag(2)
            // 3a. the view to show login page
            if (client.isLoggedIn) {
                ProfileTabView(client: client)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(3)
            // 3b. the view shows profile if logged in
            } else {
                Text("ProfileTabView")
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(3)
            }
            // 4. the view shows all the friends
            FriendTabView(client: client)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends")
                }
                .tag(4)
            // 5. the view shows setting info
            SettingTabView(client: client)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Settings")
                }
                .tag(5)
        }
    }
}

#if DEBUG
struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(client: VRChatClient.createPreview())
    }
}
#endif
