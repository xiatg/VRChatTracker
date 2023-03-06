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
    
    let user:User
    
    init(client: VRChatClient) {
        self.client = client
        
        self.user = client.user!
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                AsyncImage(url: URL(string: user.currentAvatarImageUrl!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                VStack {
                    if (user.userIcon ?? "" != "") {
                        AsyncImage(url: URL(string: user.userIcon!)) { image in
                                image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 200)
                                .clipShape(Circle())
                                .overlay {
                                    Circle().stroke(.white, lineWidth: 4)
                                }
                                .shadow(radius: 7)
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text("\(user.displayName!)")
                        .font(.title)
                        .bold()
                    
                    Text("\(user.statusDescription!)")
                        .padding(.top, -10)
                    
                    HStack {
                        Text("\(user.state!)")
                        
                        Text("\(user.status!)")
                    }
                    .padding(.top)
  
                    HStack {
                        ForEach(user.tags!, id: \.self) { tag in
                            if (tag.starts(with: "language")) {
                                Button(action: nothing) {
                                    Text(tag.suffix(3).uppercased())
                                }
                            }
                        }
                        if (user.tags!.count < 4) {
                            Button(action: nothing) {
                                Image(systemName: "plus.circle")
                            }
                        }
                    }
                    .padding(.top, -7)
                    
                    HStack {
                        Text(user.bio!)
                            .multilineTextAlignment(.leading)
                        .padding(.top)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 10.0)
                .offset(y: ((user.userIcon ?? "") == "") ? 0 : -100)
            }
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
//            .navigationTitle(user.displayName!)
        }
        .refreshable {
            client.loginUserInfo()
        }
        .statusBarHidden()
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(client: VRChatClient.createPreview())
    }
}
