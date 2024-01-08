//
//  AvatarTabView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 3/3/23.
//

import SwiftUI

struct AvatarTabView: View {
    
    // search bar text
    @State private var searchText = ""
    
    // the observable VRChat cilent instance
    @ObservedObject var client: VRChatClient

    var body: some View {
        
        NavigationStack {
            List {
                if let favoritedAvatarList = client.favoritedAvatarList {
                    Section("Favorited Avatars") {
                        AvatarRowView(client: client, avatars: favoritedAvatarList)
                    }
                }
                
                if let avatarList = client.avatarList {
                    Section("Featured Avatars") {
                        AvatarRowView(client: client, avatars: avatarList)
                    }
                }
            }
            .navigationTitle("Avatars")
        }
        .refreshable {
            client.getAvatars()
        }
        .onAppear {
            client.getAvatars()
        }
    }
}

struct AvatarRowView: View {
    @ObservedObject var client: VRChatClient
    
    let avatars: [VRAvatar]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 5) {
                ForEach(avatars.sorted{ $0.updated_at! > $1.updated_at! }) { avatar in
                    
                    NavigationLink {
                        // if clicked, load the detail view
                        AvatarDetailView(avatar: avatar)
                    } label: {
                        VStack{
                            Divider()
                            // avatar name
                            Text(avatar.name!)
                                .foregroundColor(.white)
                                .bold()
                            // avatar name
                            AsyncImage(url: URL(string: avatar.imageUrl!)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            } placeholder: {
                                // placeholder while the image is loading
                                Image("cat")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                            .cornerRadius(10)
                            .padding(.bottom, 5)
                        }
                        .background(Color("BackgroundColor"))
                        .cornerRadius(20)
                        .frame(width: 300, height: 200)
                    }
                }
            }
        }
    }
}

#if DEBUG
struct AvatarTabView_Previews: PreviewProvider {
    static var previews: some View {
//        let avatarList: [VRAvatar] = [avatarExample1, avatarExample2, avatarExample3]
//        AvatarTabView(avatarList: avatarList)
        AvatarTabView(client: VRChatClient.createPreview())
    }
}
#endif
