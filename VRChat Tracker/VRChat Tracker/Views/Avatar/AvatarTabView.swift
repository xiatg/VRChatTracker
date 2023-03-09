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
    
    // the stored metadata of three avatars
    // if the internet is disconnected, load the pre-stored data
    var avatarExamples: [VRAvatar] = [avatarExample1, avatarExample2, avatarExample3]
    
    var body: some View {
        // fetch avatar list data from the API
        let avatarList = client.avatarList != nil ? client.avatarList! : avatarExamples
        NavigationStack {
            // search bar to search avatars
            SearchBarView(text: $searchText)
                .padding([.leading, .trailing, .bottom], 16)
            // list all the avatar info
            List (avatarList.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false })) { item in
                NavigationLink {
                    // if clicked, load the detail view
                    AvatarDetailView(avatar: item)
                } label: {
                    VStack{
                        Divider()
                        // avatar name
                        Text(item.name!)
                            .foregroundColor(.white)
                            .bold()
                        // avatar name
                        AsyncImage(url: URL(string: item.imageUrl!)) { image in
                            image
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaledToFit()
                                .overlay {
                                    Rectangle().stroke(.black, lineWidth: 0.1)
                                }
                        } placeholder: {
                            // placeholder while the image is loading
                            Image("cat")
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaledToFit()
                                .overlay {
                                    Rectangle().stroke(.black, lineWidth: 0.1)
                                }
                        }
                    }
                    .background(Color("BackgroundColor"))
                }
            }
            .navigationTitle("Discover Avatars")
        }
        // refresh/pull down the screen to load more avatars
        .refreshable {
            client.getAvatars()
        }
    }
}

struct AvatarTabView_Previews: PreviewProvider {
    static var previews: some View {
//        let avatarList: [VRAvatar] = [avatarExample1, avatarExample2, avatarExample3]
//        AvatarTabView(avatarList: avatarList)
        AvatarTabView(client: VRChatClient.createPreview())
    }
}
