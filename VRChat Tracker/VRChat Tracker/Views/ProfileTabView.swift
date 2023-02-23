//
//  ProfileTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/19/23.
//

import SwiftUI
import SwiftVRChatAPI

struct ProfileTabView: View {
    @ObservedObject var client: VRChatClient
    
    let displayName: String
    let username: String
    let currentAvatarImageUrl: String
    let tags: [String]
    let bio: String
    
    init(client: VRChatClient) {
        self.client = client
        
        self.displayName = client.userInfo!.displayName!
        self.username = client.userInfo!.username!
        self.currentAvatarImageUrl = client.userInfo!.currentAvatarImageUrl!
        self.tags = client.userInfo!.tags!
        self.bio = client.userInfo!.bio!
        
        // https://stackoverflow.com/questions/69325928/swiftui-size-to-fit-or-word-wrap-navigation-title
        UILabel.appearance(whenContainedInInstancesOf: [UINavigationBar.self]).adjustsFontSizeToFitWidth = true
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text("@\(username)")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Spacer()
                }
                
                AsyncImage(url: URL(string: currentAvatarImageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                HStack {
                    ForEach(tags, id: \.self) { tag in
                        if (tag.starts(with: "language")) {
                            Button(action: nothing) {
                                Text(tag.suffix(3).uppercased())
                            }
                        }
                    }
                    if (tags.count < 4) {
                        Button(action: nothing) {
                            Image(systemName: "plus.circle")
                        }
                    }
                }
                
                HStack {
                    Text(bio)
                        .multilineTextAlignment(.leading)
                    .padding(.top)
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.horizontal, 10.0)
            .navigationTitle(displayName)
            
        }
    }
}

func nothing() {
    
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(client: VRChatClient.createPreview())
    }
}
