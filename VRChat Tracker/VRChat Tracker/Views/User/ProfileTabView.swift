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
    
    @State private var bio: String
    @FocusState private var isEditingBio: Bool
    
    @State private var newLanguageSelection = "ADD"
    
    @State private var toDeleteLanguageTag = ""
    @State private var showDeleteLanguageTagAlert = false
    
    @State private var isLoading = false
    
    @State private var showNewBioLinkAlert = false
    @State private var newBioLink = "https://"
    
    @State private var toDeleteBioLink = ""
    @State private var showDeleteBioLinkAlert = false
    
    init(client: VRChatClient) {
        self.client = client
        
        self.user = client.user!
        
        self._statusDescription = State(initialValue: self.user.statusDescription!)
        self._bio = State(initialValue: self.user.bio!.replacingOccurrences(of: "⁄", with: "/").replacingOccurrences(of: "＃", with: "#").replacingOccurrences(of: "˸", with: ":").replacingOccurrences(of: "（", with: "(").replacingOccurrences(of: "）", with: ")").replacingOccurrences(of: "∗", with: "*").replacingOccurrences(of: "＂", with: "\""))
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
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
                                    .limitInputLength(value: $statusDescription, length: 32)
                                    .padding(.top, -15)
                                
                                if (isEditingDescription) {
                                    Button {
                                        Task {
                                            isLoading = true
                                            await client.updateStatusDescription(statusDescription: statusDescription)
                                            isEditingDescription.toggle()
                                            isLoading = false
                                        }
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
                                        Button(action: {}) {
                                            Text(toEmoji(languageAbbr: tag.suffix(3).lowercased()))
                                        }
                                        .simultaneousGesture(LongPressGesture().onEnded({ _ in
                                            toDeleteLanguageTag = tag
                                            showDeleteLanguageTagAlert.toggle()
                                        }))
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
                                                newLanguageSelection = "ADD"
                                                isLoading = false
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.top, -7)
                            .alert("Delete Spoken Language", isPresented: $showDeleteLanguageTagAlert) {
                                Button("Cancel") {
                                    showDeleteLanguageTagAlert.toggle()
                                }
                                Button("Delete") {
                                    Task {
                                        isLoading = true
                                        await client.deleteTags(tags: [toDeleteLanguageTag])
                                        isLoading = false
                                    }
                                }
                            } message: {
                                Text("Are you sure you want to delete \n \(toEmoji(languageAbbr: toDeleteLanguageTag.suffix(3).lowercased())) \n from your spoken language?")
                            }
                            
                            HStack {
                                ForEach(user.bioLinks!, id: \.self) { bioLink in
                                    BioLinkView(bioLink: bioLink)
                                        .simultaneousGesture(LongPressGesture().onEnded({ _ in
                                            toDeleteBioLink = bioLink
                                            showDeleteBioLinkAlert.toggle()
                                        }))
                                        .simultaneousGesture(TapGesture().onEnded({ _ in
                                            UIApplication.shared.open(URL(string: bioLink)!)
                                        }))
                                }
                                
                                if (user.bioLinks!.count < 3) {
                                    Button {
                                        showNewBioLinkAlert.toggle()
                                    } label: {
                                        Image(systemName: "plus.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 20, height: 20)
                                            .clipShape(Circle())
                                    }
                                    .alert("New Biolink", isPresented: $showNewBioLinkAlert) {
                                        TextField("https://", text: $newBioLink)
                                            .textInputAutocapitalization(.never)
                                            .autocorrectionDisabled(true)
                                        Button("Cancel") {
                                            showNewBioLinkAlert.toggle()
                                        }
                                        Button("Add") {
                                            Task {
                                                isLoading = true
                                                await client.addBioLinks(bioLinks: [newBioLink])
                                                isLoading = false
                                            }
                                        }
                                    }
                                    .buttonStyle(.automatic)
                                    .padding(.horizontal, 10)
                                    .clipShape(Circle())
                                }
                            }
                            .alert("Delete BioLink", isPresented: $showDeleteBioLinkAlert) {
                                Button("Cancel") {
                                    showDeleteBioLinkAlert.toggle()
                                }
                                Button("Delete") {
                                    Task {
                                        isLoading = true
                                        await client.deleteBioLinks(bioLinks: [toDeleteBioLink])
                                        isLoading = false
                                    }
                                }
                            } message: {
                                Text("Are you sure you want to delete \n \(toDeleteBioLink) \n from your biolinks?")
                            }
                            
                            if (isEditingBio) {
                                Button {
                                    Task {
                                        isLoading = true
                                        await client.updateBio(bio: bio)
                                        isEditingBio.toggle()
                                        isLoading = false
                                    }
                                } label: {
                                    Text("Update")
                                }
                                .buttonStyle(.bordered)
                            }
                            
                            HStack {
                                // user info
                                TextField("", text: $bio, axis: .vertical)
                                    .focused($isEditingBio)
                                    .multilineTextAlignment(.leading)
                                    .limitInputLength(value: $bio, length: 512)
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
                    
                    Spacer()
                }
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

// https://sanzaru84.medium.com/swiftui-an-updated-approach-to-limit-the-amount-of-characters-in-a-textfield-view-984c942a156

import Combine

struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        if #available(iOS 14, *) {
            content
                .onChange(of: $value.wrappedValue) {
                    value = String($0.prefix(length))
                }
        } else {
            content
                .onReceive(Just(value)) {
                    value = String($0.prefix(length))
                }
        }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}

struct ProfileTabView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTabView(client: VRChatClient.createPreview())
    }
}
