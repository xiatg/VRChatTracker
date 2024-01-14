//
//  FriendTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import SwiftUI

struct FriendTabView: View {
    
    // observable instance of vrchat client
    @ObservedObject var client: VRChatClient
    
    // search bar text
    @State private var searchName = ""
    
    let refreshableToggle = true
    
    var body: some View {
        NavigationStack {
            List {
                // list of online friends
                if let onlineFriends = client.onlineFriends {
                    Section("Online Friends") {
                        FriendRowView(friends: onlineFriends)
                    }
                }
                // list of currently active friends
                if let activeFriends = client.activeFriends {
                    Section("Active Friends") {
                        FriendRowView(friends: activeFriends)
                    }
                }
                // list offline friends
                if let offlineFriends = client.offlineFriends {
                    Section("Offline Friends") {
                        FriendRowView(friends: offlineFriends)
                    }
                }
            }
            .navigationTitle("Friends")
        }
        // search bar
        .searchable(text: $searchName, prompt: "Search for friends...") {
            ScrollView {
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
        }
        // refresh the list to load updated friends info
        .refreshable {
            client.updateFriends()
        }
        .onAppear {
            client.updateFriends()
        }
    }
    
    // update friend list while using the search bar with filter
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

            return friends.filter{ ($0.user.displayName ?? "[ERR] Unknown Name, contact developer").localizedCaseInsensitiveContains(searchName) }
        }
    }
}

struct FriendRowView: View {
    let friends: [Friend]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 5) {
                ForEach(friends.sorted{ ($0.user.displayName ?? "[ERR] Unknown Name, contact developer") < ($1.user.displayName ?? "[ERR] Unknown Name, contact developer")}) { friend in
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

#if DEBUG
struct FriendTabView_Previews: PreviewProvider {
    static var previews: some View {
        FriendTabView(client: VRChatClient.createPreview())
    }
}
#endif
