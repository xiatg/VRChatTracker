//
//  ProfileTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/19/23.
//

import SwiftUI

struct ProfileTabView: View {
    let displayName: String
    let username: String
    let currentAvatarImageUrl: String
    let tags: [String]
    let bio: String
    
    init(displayName: String, username: String, currentAvatarImageUrl: String, tags: [String], bio: String) {
        self.displayName = displayName
        self.username = username
        self.currentAvatarImageUrl = currentAvatarImageUrl
        self.tags = tags
        self.bio = bio
        
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
        ProfileTabView(displayName: "Natsuki关注永雏塔菲喵", username: "sunny915915", currentAvatarImageUrl: "https://api.vrchat.cloud/api/1/file/file_ea36dd11-163e-4511-979a-8ed1f01f3793/1/file",
                       tags: [
                        "system_no_captcha",
                        "language_eng",
                        "language_jpn"
                       ], bio: """
Male男（He⁄Him）INTJ-T
Hello 你好 こんにちは
EN⁄CN⁄粵⁄JP
GMT-5
"""
                    )
    }
}
