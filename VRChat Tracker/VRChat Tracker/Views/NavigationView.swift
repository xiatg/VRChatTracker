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
            WorldTabView()
                .tabItem {
                    Image(systemName: "globe")
                    Text("World")
                }
                .tag(1)
            Text("AvatarTabView")
                .tabItem {
                    Image(systemName: "theatermasks")
                    Text("Avatar")
                }
                .tag(2)
            if (client.isLoggedIn) {
                ProfileTabView(client: client)
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(3)
            } else {
                Text("ProfileTabView")
                    .tabItem {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                    .tag(3)
            }
            FriendTabView(client: client)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Friends")
                }
                .tag(4)
            SettingTabView(client: client)
                .tabItem {
                    Image(systemName: "gear")
                    Text("Setting")
                }
                .tag(4)
        }
    }
}

struct NavigationView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView(client: VRChatClient.createPreview())
    }
}
