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
    
    @State private var statusDescription: String
    @FocusState private var isEditingDescription: Bool
    @State private var languageTagCount = 0
    @State private var newLanguageSelection = "ADD"
    @State private var isLoading = false
    
    init(client: VRChatClient) {
        self.client = client
        
        self.user = client.user!
        
        self._statusDescription = State(initialValue: self.user.statusDescription!)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ScrollView {
                    // current user avatar image
                    AsyncImage(url: URL(string: user.currentAvatarImageUrl!)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                            .frame(height: 400)
                    }
                    
                    VStack {
                        // user icon/image
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
                        // user name
                        Text("\(user.displayName!)")
                            .font(.title)
                            .bold()
                        // user status
                        
                        
                        VStack {
                            TextField("", text: $statusDescription, axis: .vertical)
                                .focused($isEditingDescription)
                                .multilineTextAlignment(.center)
                                .frame(height: 60)
                            
                            if (isEditingDescription) {
                                Button {
                                    isEditingDescription.toggle()
                                } label: {
                                    Text("Update")
                                }
                                .buttonStyle(.bordered)
                            }
                        }
                        
                        HStack {
                            Text("\(user.state!)")
                            
                            Text("\(user.status!)")
                        }
                        .padding(.top)
      
                        HStack {
                            // user language tags
                            ForEach(user.tags!, id: \.self) { tag in
                                if (tag.starts(with: "language")) {
                                    Button {
                                        Task {
                                            isLoading = true
                                            await client.deleteTags(tags: [tag])
                                            newLanguageSelection = "ADD"
                                            isLoading = false
                                        }
                                    } label: {
                                        Text(toEmoji(languageAbbr: tag.suffix(3).lowercased()))
                                    }
                                    .buttonStyle(.bordered)
                                }
                            }
                            if (user.tags!.filter{ (tag) -> Bool in return tag.contains("language")}.count < 3) {
                                Picker("Add", selection: $newLanguageSelection) {
                                    ForEach(languagesAbbrs.filter{ (abbr) -> Bool in return !(user.tags!.contains("language_\(abbr)")) } , id: \.self) {
                                        Text(toEmoji(languageAbbr: $0))
                                    }
                                }
                                .onChange(of: newLanguageSelection) { newValue in
                                    if newValue != "ADD" {
                                        Task {
                                            isLoading = true
                                            await client.addTags(tags: ["language_\(newValue)"])
                                            isLoading = false
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.top, -7)
                        
                        HStack {
                            // user info
                            Text(user.bio!.replacingOccurrences(of: "⁄", with: "/").replacingOccurrences(of: "＃", with: "#"))
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
            }
            .refreshable {
                client.loginUserInfo()
            }
            .statusBarHidden()
            
            if (isLoading) {
                LoadingView()
            }
        }
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(client: VRChatClient.createPreview())
    }
}
