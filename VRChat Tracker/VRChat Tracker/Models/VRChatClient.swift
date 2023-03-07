//
//  VRChatClient.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import Foundation
import SwiftVRChatAPI

class VRChatClient: ObservableObject {
    
    // LoginView
    @Published var isLoggedIn = false
    @Published var is2FA = false
    @Published var isAutoLoggingIn = false
    
    // ProfileTabView
    @Published var user: User?
    
    // FriendTabView
    @Published var onlineFriends: [Friend]?
    @Published var activeFriends: [Friend]?
    @Published var offlineFriends: [Friend]?
    
    // WorldTabView
    @Published var worldList: [VRWorld]?
    
    // AvatarTabView
    @Published var avatarList: [VRAvatar]?
    
    var apiClient = APIClient()
    
    var preview = false
    
    init(autoLogin: Bool = true, preview: Bool = false) {
        
        self.preview = preview
        
        // Fetch the currently available cookies
        apiClient.updateCookies()
        
        if (autoLogin) {
            isAutoLoggingIn = true
            // Try to login with available cookies
            loginUserInfo()
        }
    }
    
    //
    // MARK: Authentication
    //
    
    func loginUserInfo() {
        AuthenticationAPI.loginUserInfo(client: self.apiClient) { user in
            
            //Debug
            print("** loginUserInfo() 1 **")
            //Debug End
            
            DispatchQueue.main.async {
                self.user = user
                
                // If already successfully logged in
                if (self.user?.displayName != nil) {
                    self.isLoggedIn = true
                } else if (self.user?.requiresTwoFactorAuth == ["emailOtp"]) {
                    self.isLoggedIn = false
                    self.is2FA = true
                }
                
                self.isAutoLoggingIn = false
            }
            
            //Debug
            print("** loginUserInfo() **")
            print(self.isLoggedIn)
            print(self.is2FA)
            //Debug End
        }
    }
    
    func email2FALogin(emailOTP: String) {
        AuthenticationAPI.verify2FAEmail(client: self.apiClient, emailOTP: emailOTP) { verify in
            guard let verify = verify else { return }
            
            //Debug
            print("** email2FALogin() **")
            print(verify)
            //Debug End
            
            if (verify) {
                self.loginUserInfo()
            }
        }
    }
    
    func clear() {
        self.isLoggedIn = false
        self.is2FA = false
        self.isAutoLoggingIn = false
        self.user = nil
    }
    
    //
    // MARK: User
    //
    
    func updateFriends() {
        
        if (self.preview) {
            return 
        }
        
        self.onlineFriends = []
        self.activeFriends = []
        self.offlineFriends = []
        
        if let user = user {
            for userID in user.onlineFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }
                    
                    let worldID = user.worldId!
                    let instanceID = user.instanceId!
            
                    if (worldID != "private") {
                        InstanceAPI.getInstance(client: self.apiClient, worldID: worldID, instanceID: instanceID) { instance in
                            WorldAPI.getWorld(client: self.apiClient, worldID: worldID) { world in
                                DispatchQueue.main.sync {
                                    self.onlineFriends?.append(Friend(user: user, world: world, instance: instance))
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.onlineFriends?.append(Friend(user: user))
                        }
                    }
                    
    //                print("** onlineFriends() **")
    //                print(self.onlineFriends)
                    
                }
            }
            
            for userID in user.activeFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }

                    DispatchQueue.main.async {
                        self.activeFriends?.append(Friend(user: user))
                    }
                }
            }
            
            for userID in user.offlineFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }

                    DispatchQueue.main.async {
                        self.offlineFriends?.append(Friend(user: user))
                    }
                }
            }
        }
    }
    
    func getWorlds() {
        WorldAPI.searchWorld(client: apiClient) { worlds in
            if let worlds = worlds {
                for item in worlds {
                    let newWorld: VRWorld = VRWorld(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, favorites: item.favorites, visits: item.visits, capacity: item.capacity, created_at: item.created_at, updated_at: item.updated_at)
                    self.worldList?.append(newWorld)
                }
            } else {
                print("Error: Failed to retrieve worlds")
            }
        }
    }
    
    func getAvatars() {
        AvatarAPI.searchAvatar(client: apiClient) { avatars in
            if let avatars = avatars {
                for item in avatars {
                    let newAvatar: VRAvatar = VRAvatar(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, updated_at: item.updated_at)
                    self.avatarList?.append(newAvatar)
                }
            } else {
                print("Error: Failed to retrieve avatars")
            }
        }
    }
    
//    func updateFriendsGroup(friends: [String]) {
//        for userID in friends {
//            UserAPI.
//        }
//    }
    
    /**
     Create a sample `VRChatClient` instance for preview.
     */
    static func createPreview() -> VRChatClient {
        let client_preview = VRChatClient(autoLogin: false, preview: true)
        
        client_preview.user = PreviewData.load(name: "UserPreview")
        
        client_preview.isLoggedIn = true
        
        client_preview.onlineFriends = [Friend(user: client_preview.user!,
                                               world: PreviewData.load(name: "WorldPreview"),
                                               instance: PreviewData.load(name: "InstancePreview"))]
        
        return client_preview
    }
}

func nothing() {
    
}
