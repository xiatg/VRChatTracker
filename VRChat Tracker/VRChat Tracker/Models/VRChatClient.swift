//
//  VRChatClient.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import Foundation
import SwiftVRChatAPI
import Network

class VRChatClient: ObservableObject {
    
    // LoginView
    @Published var isLoggedIn = false
    @Published var is2FA = false
    @Published var isAutoLoggingIn = false
    @Published var showNoInternetAlert = false
    
    let monitor = NWPathMonitor()
    
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
    
    // WorldDetailView
    @Published var worldDetail: VRWorld?
    
    // AvatarDetailView
    @Published var avatarDetail: VRAvatar?
    
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
    
    /**
     Handle User Login Functionality
     
     If user enters correct username and password, prompt to MFA.
     
     If passes MFA, log the user in.
     */
    func loginUserInfo() {
        
        
        //Debug
        print("** loginUserInfo() 0 **")
        //Debug End
        
        //https://www.hackingwithswift.com/example-code/networking/how-to-check-for-internet-connectivity-using-nwpathmonitor
        monitor.pathUpdateHandler = { path in
            
            if path.status != .satisfied {
                
                DispatchQueue.main.async {
                    self.isAutoLoggingIn = false
                    self.showNoInternetAlert = true
                }
                
            } else {
                
                AuthenticationAPI.loginUserInfo(client: self.apiClient) { user in
                    
                    //Logging
                    if let user = user {
                        print("[LOGGING]: Downloaded user information: \(user)")
                    }
                    
                    
                    DispatchQueue.main.async {
                        self.user = user
                        
                        // If already successfully logged in
                        if (self.user?.displayName != nil) {
                            self.isLoggedIn = true
                        } else if (self.user?.requiresTwoFactorAuth == ["emailOtp"]) {
                            self.isLoggedIn = false
                            self.is2FA = true
                        }
                    }
                    
                    //Debug
                    print("** loginUserInfo() 3 **")
                    print(self.isLoggedIn)
                    print(self.is2FA)
                    //Debug End
                }
                
                DispatchQueue.main.async {
                    self.isAutoLoggingIn = false
                }
            }
        }
        
        monitor.start(queue: DispatchQueue.main)
    }
    
    /**
     Varify MFA with user input code from email.

     - Parameter emailOTP: a string code the user enters.
     */
    func email2FALogin(emailOTP: String) {
        AuthenticationAPI.verify2FAEmail(client: self.apiClient, emailOTP: emailOTP) { verify in
            guard let verify = verify else { return }
            
            //Logging
            print("[LOGGING]: Downloaded verification information: \(verify)")
            
            if (verify) {
                self.loginUserInfo()
            }
        }
    }
    
    /**
     Cancel user login action, or log the user out. Clean everything.
     */
    func clear() {
        self.isLoggedIn = false
        self.is2FA = false
        self.isAutoLoggingIn = false
        self.user = nil
    }
    
    //
    // MARK: User
    //
    
    /**
     Update the data for three friend lists. By using the API the fetch friends' data and insert them into three different lists.
     1. online friends
     2. active friends
     3. offline friends
     */
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
                    
                    //Logging
                    print("[LOGGING]: Downloaded user information: \(user)")
                    
                    let worldID = user.worldId!
                    let instanceID = user.instanceId!
            
                    if (worldID != "private" && worldID != "traveling" && worldID != "offline" && worldID != "privateOffline") {
                        InstanceAPI.getInstance(client: self.apiClient, worldID: worldID, instanceID: instanceID) { instance in
                            
                            //Logging
                            if let instance = instance {
                                print("[LOGGING]: Downloaded instance information: \(instance)")
                            }
                            
                            WorldAPI.getWorld(client: self.apiClient, worldID: worldID) { world in
                                
                                //Logging
                                if let world = world {
                                    print("[LOGGING]: Downloaded world information: \(world)")
                                }
                                
                                
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

                    //Logging
                    print("[LOGGING]: Downloaded user information: \(user)")
                    
                    DispatchQueue.main.async {
                        self.activeFriends?.append(Friend(user: user))
                    }
                }
            }
            
            for userID in user.offlineFriends! {
                UserAPI.getUser(client: apiClient, userID: userID) { user in
                    guard let user = user else { return }

                    //Logging
                    print("[LOGGING]: Downloaded user information: \(user)")
                    
                    DispatchQueue.main.async {
                        self.offlineFriends?.append(Friend(user: user))
                    }
                }
            }
        }
    }
    
    /**
     Update data for world list, so the user is able to discover all the worlds.
     
     By using the API the fetch worlds' data and insert them into a list.
     */
    func getWorlds() {
        self.worldList = []
        WorldAPI.searchWorld(client: apiClient) { worlds in
            if let worlds = worlds {
                for item in worlds {
                    
                    //Logging
                    print("[LOGGING]: Downloaded world information: \(item)")
                    
                    let newWorld: VRWorld = VRWorld(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, favorites: item.favorites, visits: item.visits, capacity: item.capacity, created_at: item.created_at, updated_at: item.updated_at)
                    
                    DispatchQueue.main.async {
                        self.worldList?.append(newWorld)
                    }
                    
                }
            } else {
                print("Error: Failed to retrieve worlds")
            }
        }
        
//        print(self.worldList)
    }
    
    /**
     Update data for avatar list, so the user is able to discover all the avatars.
     
     By using the API the fetch avatars' data and insert them into a list.
     */
    func getAvatars() {
        self.avatarList = []
        AvatarAPI.searchAvatar(client: apiClient) { avatars in
            if let avatars = avatars {
                for item in avatars {
                    
                    //Logging
                    print("[LOGGING]: Downloaded avatar information: \(item)")
                    
                    let newAvatar: VRAvatar = VRAvatar(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, updated_at: item.updated_at)
                    
                    DispatchQueue.main.async {
                        self.avatarList?.append(newAvatar)
                    }
                }
            } else {
                print("Error: Failed to retrieve avatars")
            }
        }
        
//        print(self.avatarList)
    }
    
    /**
     Update data for a single world that user clicks in the worlds' list, so that the detail view can display the stats.

     - Parameter worldId: The id of a world that the user clicks in the list.
     */
    func fetchWorld(worldId: String) {
        WorldAPI.getWorld(client: apiClient, worldID: worldId) { world in
            if let world = world {
                let newWorld: VRWorld = VRWorld(name: world.name, id: world.id, authorName: world.authorName, imageUrl: world.imageUrl, description: world.description, authorId: world.authorId, favorites: world.favorites, visits: world.visits, capacity: world.capacity, created_at: world.created_at, updated_at: world.updated_at)
                
                DispatchQueue.main.async {
                    self.worldDetail = newWorld
                }
            }
            else {
                print("No such world exist, please double check the world id: \(worldId)")
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
