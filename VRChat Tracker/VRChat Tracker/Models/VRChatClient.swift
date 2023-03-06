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
