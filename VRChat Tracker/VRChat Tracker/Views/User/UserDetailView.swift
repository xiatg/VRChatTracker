//
//  UserDetailView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/24/23.
//

import SwiftUI
import SwiftVRChatAPI

struct UserDetailView: View {
    let user:User
    let world: World?
    let instance: Instance?
    
    init(user: User, world: World? = nil, instance: Instance? = nil) {
        self.user = user
        self.world = world
        self.instance = instance
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                // display current user avatar
                AsyncImage(url: URL(string: user.currentAvatarImageUrl!)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                
                VStack {
                    // display user icon
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
                    
                    // display user name
                    Text("\(user.displayName!)")
                        .font(.title)
                        .bold()
                    
                    // display user current status
                    Text("\(user.statusDescription!)")
                        .padding(.top, -10)
                    
                    HStack {
                        Text("\(user.state!)")
                        
                        Text("\(user.status!)")
                    }
                    .padding(.top)
  
                    // display language tags
                    HStack {
                        ForEach(user.tags!, id: \.self) { tag in
                            if (tag.starts(with: "language")) {
                                Button(action: nothing) {
                                    Text(toEmoji(languageAbbr: tag.suffix(3).lowercased()))
                                }
                                .buttonStyle(.bordered)
                                .foregroundColor(.primary)
                            }
                        }
                    }
                    .padding(.top, -7)
                    
                    HStack {
                        ForEach(user.bioLinks!, id: \.self) { bioLink in
                            BioLinkView(bioLink: bioLink)
                                .simultaneousGesture(TapGesture().onEnded({ _ in
                                    if let url = URL(string: bioLink) {
                                        UIApplication.shared.open(url)
                                    } else {
                                        print("unable to parse link into URL \"\(bioLink)\"")
                                    }
                                }))
                        }
                    }
                    
                    // display user info/descriptions
                    HStack {
                        Text(user.bio!.replacingOccurrences(of: "⁄", with: "/").replacingOccurrences(of: "＃", with: "#").replacingOccurrences(of: "˸", with: ":").replacingOccurrences(of: "（", with: "(").replacingOccurrences(of: "）", with: ")").replacingOccurrences(of: "∗", with: "*").replacingOccurrences(of: "＂", with: "\""))
                            .multilineTextAlignment(.leading)
                        .padding(.top)
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 10.0)
                .offset(y: ((user.userIcon ?? "") == "") ? 0 : -100)
            }
//            .navigationBarBackButtonHidden(true)
            .scrollIndicators(.hidden)
            .ignoresSafeArea()
//            .navigationTitle(user.displayName!)
        }
    }
}

#if DEBUG
struct UserDetailView_Previews: PreviewProvider {
    static var previews: some View {
        UserDetailView(user: PreviewData.load(name: "UserPreview")!,
                       world: PreviewData.load(name: "WorldPreview")!,
                       instance: PreviewData.load(name: "InstancePreview")!)
    }
}
#endif
