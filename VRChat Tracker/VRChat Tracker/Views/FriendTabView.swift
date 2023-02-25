//
//  FriendTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import SwiftUI
import SwiftVRChatAPI

struct FriendTabView: View {
    @ObservedObject var client: VRChatClient
    
    @State private var searchName = ""
    
    let refreshableToggle = true
    
    var body: some View {
        NavigationStack {
            List {
                if let onlineFriends = client.onlineFriends {
                    Section("Online Friends") {
                        FriendRowView(friends: onlineFriends)
                    }
                }
                if let activeFriends = client.activeFriends {
                    Section("Active Friends") {
                        FriendRowView(friends: activeFriends)
                    }
                }
                if let offlineFriends = client.offlineFriends {
                    Section("Offline Friends") {
                        FriendRowView(friends: offlineFriends)
                    }
                }
            }
            .navigationTitle("Friends")
        }
        .searchable(text: $searchName, prompt: "Search for friends...") {
            LazyVStack {
                ForEach(searchResults) { friend in
                    NavigationLink {
                        UserDetailView(user: friend.user)
                    } label: {
                        UserView(user: friend.user, world: friend.world, instance: friend.instance)
                            .cornerRadius(10)
                    }
                }
            }
        }
        .refreshable {
            client.updateFriends()
        }
        .onAppear {
            client.updateFriends()
        }
    }
    
    var searchResults: [Friend] {
        if searchName.isEmpty {
            return []
        } else {
            
            var friends:[Friend] = []
            
            if let onlineFriends = client.onlineFriends {
                friends += onlineFriends
            }
            if let activeFriends = client.activeFriends {
                friends += activeFriends
            }
            if let offlineFriends = client.offlineFriends {
                friends += offlineFriends
            }
            
            return friends.filter{ $0.user.displayName!.localizedCaseInsensitiveContains(searchName) }
        }
    }
}

struct FriendRowView: View {
    let friends: [Friend]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 5) {
                ForEach(friends) { friend in
                    NavigationLink {
                        UserDetailView(user: friend.user)
                    } label: {
                        UserView(user: friend.user, world: friend.world, instance: friend.instance)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }
}

struct FriendTabView_Previews: PreviewProvider {
    static var previews: some View {
        FriendTabView(client: VRChatClient.createPreview())
    }
}
