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
    @Published var twoFactorAuthMethod: String?
    @Published var isAutoLoggingIn: Bool
    @Published var showErrorMessage = false
    @Published var errorMessage = ""
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
    @Published var favoritedWorldList: [VRWorld]?
    
    // AvatarTabView
    @Published var avatarList: [VRAvatar]?
    @Published var favoritedAvatarList: [VRAvatar]?
    
    // WorldDetailView
    @Published var worldDetail: VRWorld?
    
    // AvatarDetailView
    @Published var avatarDetail: VRAvatar?
    
    @Published var favoritedWorldIdList: [String]?
    @Published var favoritedAvatarIdList: [String]?
    @Published var favoritedFriendIdList: [String]?
    
    var apiClient = APIClient()
    var apiClientAsync = APIClientAsync()
    
    var preview = false
    
    init(autoLogin: Bool = true, preview: Bool = false) {
        
        self.isAutoLoggingIn = autoLogin
        self.preview = preview
        
        // Fetch the currently available cookies
        apiClient.updateCookies()
        apiClientAsync.updateCookies()
        
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
    func loginUserInfoAsync() async {
        let user = await AuthenticationAPIAsync.loginUserInfo(client: self.apiClientAsync)

        DispatchQueue.main.async {
            self.user = user
            
            guard let user = self.user else { return }
            
            // If already successfully logged in
            if (user.displayName != nil) {
                self.isLoggedIn = true
            } else if let twoFactorAuthMethods = user.requiresTwoFactorAuth {
                if twoFactorAuthMethods.contains("emailOtp") {
                    self.twoFactorAuthMethod = "emailOtp"
                    self.isLoggedIn = false
                    self.is2FA = true
                } else if twoFactorAuthMethods.contains("totp") {
                    self.twoFactorAuthMethod = "totp"
                    self.isLoggedIn = false
                    self.is2FA = true
                } else {
                    self.errorMessage = "Unknown two factor authentication method."
                    self.showErrorMessage = true
                }
            } else if let error = user.error {
                self.errorMessage = error.message!
                self.showErrorMessage = true
            } else {
                self.errorMessage = "Uncaught error occurred."
                self.showErrorMessage = true
            }
        }
        
        if user?.displayName != nil {
            await getFavoritesAsync()
        }
        
        apiClient.updateCookies()
    }
    
    /**
     Handle User Login Functionality
     
     If user enters correct username and password, prompt to MFA.
     
     If passes MFA, log the user in.
     */
    func loginUserInfo() {
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
                            
                            self.getFavorites()
                            
                        } else if let twoFactorAuthMethods = user?.requiresTwoFactorAuth {
                            if twoFactorAuthMethods.contains("emailOtp") {
                                self.twoFactorAuthMethod = "emailOtp"
                                self.isLoggedIn = false
                                self.is2FA = true
                            } else if twoFactorAuthMethods.contains("totp") {
                                self.twoFactorAuthMethod = "totp"
                                self.isLoggedIn = false
                                self.is2FA = true
                            } else {
                                self.errorMessage = "Unknown two factor authentication method."
                                self.showErrorMessage = true
                            }
                        }
                        
                        self.isAutoLoggingIn = false
                    }
                }
            }
        }
        
        monitor.start(queue: DispatchQueue.main)
    }
    
    /**
     Varify MFA with user input code from email.

     - Parameter emailOTP: a string code the user enters.
     */
    func email2FALoginAsync(emailOTP: String) async {
        let verify = await AuthenticationAPIAsync.verify2FAEmail(client: self.apiClientAsync, emailOTP: emailOTP)
        
        if (verify ?? false) {
            await self.loginUserInfoAsync()
        }
    }
    
    /**
     2FA with OTP.
     */
    func totp2FALoginAsync(totp: String) async {
        let verify = await AuthenticationAPIAsync.verify2FATOTP(client: self.apiClientAsync, TOTP: totp)
        
        if (verify ?? false) {
            await self.loginUserInfoAsync()
        }
    }
    
    func logoutAsync() async {
        await AuthenticationAPIAsync.logout(client: apiClientAsync)
        
        apiClient.updateCookies()
    }
    
    /**
     Cancel user login action, or log the user out. Clean everything.
     */
    func clear() {
        self.isLoggedIn = false
        self.is2FA = false
        self.twoFactorAuthMethod = nil
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
                    
                    let worldID = user.worldId!
                    let instanceID = user.instanceId!
            
                    if (worldID != "private" && worldID != "traveling" && worldID != "offline" && worldID != "privateOffline") {
                        InstanceAPI.getInstance(client: self.apiClient, worldID: worldID, instanceID: instanceID) { instance in
                            
                            WorldAPI.getWorld(client: self.apiClient, worldID: worldID) { world in
                                
                                DispatchQueue.main.async {
                                    self.onlineFriends?.append(Friend(user: user, world: world, instance: instance))
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.onlineFriends?.append(Friend(user: user))
                        }
                    }
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
    
    func updateStatusDescription(statusDescription: String) async {
        let user = await UserAPIAsync.updateUser(client: apiClientAsync, userID: user!.id!, statusDescription: statusDescription)
        
        guard user != nil else { return }
        
        await self.loginUserInfoAsync()
    }
    
    func addTags(tags: [String]) async {
        let newTags = user!.tags! + tags
        
        let user = await UserAPIAsync.updateUser(client: apiClientAsync, userID: user!.id!, tags: newTags)
        
        guard user != nil else { return }
        
        await self.loginUserInfoAsync()
    }
    
    func deleteTags(tags: [String]) async {
        
        var newTags = user!.tags!
        
        newTags.removeAll { tag in
            return tags.contains(tag)
        }
        
        let user = await UserAPIAsync.updateUser(client: apiClientAsync, userID: user!.id!, tags: newTags)

        guard user != nil else { return }

        await self.loginUserInfoAsync()
    }
    
    func updateBio(bio: String) async {
        let user = await UserAPIAsync.updateUser(client: apiClientAsync, userID: user!.id!, bio: bio)
        
        guard user != nil else { return }
        
        await self.loginUserInfoAsync()
    }
    
    func addBioLinks(bioLinks: [String]) async {
        let newBioLinks = user!.bioLinks! + bioLinks
        
        let user = await UserAPIAsync.updateUser(client: apiClientAsync, userID: user!.id!, bioLinks: newBioLinks)
        
        guard user != nil else { return }
        
        await self.loginUserInfoAsync()
    }
    
    func deleteBioLinks(bioLinks: [String]) async {
        
        var newBioLinks = user!.bioLinks!
        
        newBioLinks.removeAll { bioLink in
            return bioLinks.contains(bioLink)
        }
        
        let user = await UserAPIAsync.updateUser(client: apiClientAsync, userID: user!.id!, bioLinks: newBioLinks)
        
        guard user != nil else { return }

        await self.loginUserInfoAsync()
    }
    
    //
    // MARK: World
    //
    
    /**
     Update data for world list, so the user is able to discover all the worlds.
     
     By using the API the fetch worlds' data and insert them into a list.
     */
    func getWorlds() {
        
        if (self.preview) {
            return 
        }
        
        DispatchQueue.main.async {
            self.worldList = []
        }
        
        WorldAPI.searchWorld(client: apiClient) { worlds in
            if let worlds = worlds {
                for item in worlds {
                    
                    let newWorld: VRWorld = VRWorld(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, favorites: item.favorites, visits: item.visits, popularity: item.popularity, heat: item.heat, capacity: item.capacity, created_at: item.created_at, updated_at: item.updated_at)
                    
                    DispatchQueue.main.async {
                        self.worldList?.append(newWorld)
                    }
                    
                }
            } else {
                print("Error: Failed to retrieve worlds")
            }
        }
        
        DispatchQueue.main.async {
            self.favoritedWorldList = []
        }
         
        WorldAPI.getFavoritedWorld(client: apiClient) { worlds in
            if let worlds = worlds {
                for item in worlds {
                    
                    /** 
                     Skip if the popularity field is missing for the world. 
                     This can happen when the world is hidden.
                     */
                    if item.popularity == nil {
                        continue
                    }
                    
                    let newWorld: VRWorld = VRWorld(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, favorites: item.favorites, visits: item.visits, popularity: item.popularity, heat: item.heat, capacity: item.capacity, created_at: item.created_at, updated_at: item.updated_at)
                    
                    DispatchQueue.main.async {
                        self.favoritedWorldList?.append(newWorld)
                    }
                    
                }
            } else {
                print("Error: Failed to retrieve worlds")
            }
        }
    }
    
    /**
     Update data for a single world that user clicks in the worlds' list, so that the detail view can display the stats.

     - Parameter worldId: The id of a world that the user clicks in the list.
     */
    func fetchWorldAsync(worldId: String) async -> VRWorld? {
        let world = await WorldAPIAsync.getWorld(client: apiClientAsync, worldID: worldId)
        
        if let world = world {
            let newWorld: VRWorld = VRWorld(name: world.name, id: world.id, authorName: world.authorName, imageUrl: world.imageUrl, description: world.description, authorId: world.authorId, favorites: world.favorites, visits: world.visits, popularity: world.popularity, heat: world.heat, capacity: world.capacity, created_at: world.created_at, updated_at: world.updated_at)
            
            return newWorld
        }
        else {
            print("No such world exist, please double check the world id: \(worldId)")
            
            return nil
        }
    }
    
    /**
     Update data for a single world that user clicks in the worlds' list, so that the detail view can display the stats.

     - Parameter worldId: The id of a world that the user clicks in the list.
     */
    func fetchWorld(worldId: String) {
        WorldAPI.getWorld(client: apiClient, worldID: worldId) { world in
            if let world = world {
                let newWorld: VRWorld = VRWorld(name: world.name, id: world.id, authorName: world.authorName, imageUrl: world.imageUrl, description: world.description, authorId: world.authorId, favorites: world.favorites, visits: world.visits, popularity: world.popularity, heat: world.heat, capacity: world.capacity, created_at: world.created_at, updated_at: world.updated_at)
                
                DispatchQueue.main.async {
                    self.worldDetail = newWorld
                }
            }
            else {
                print("No such world exist, please double check the world id: \(worldId)")
            }
        }
    }
    
    //
    // MARK: Avatar
    //
    
    /**
     Update data for avatar list, so the user is able to discover all the avatars.
     
     By using the API the fetch avatars' data and insert them into a list.
     */
    func getAvatars() {
        
        if self.preview { return }
        
        self.avatarList = []
        AvatarAPI.searchAvatar(client: apiClient) { avatars in
            if let avatars = avatars {
                for item in avatars {
                    
                    let newAvatar: VRAvatar = VRAvatar(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, updated_at: item.updated_at)
                    
                    DispatchQueue.main.async {
                        
                        if newAvatar.updated_at != nil {
                            self.avatarList?.append(newAvatar)
                        }
                    }
                }
            } else {
                print("Error: Failed to retrieve avatars")
            }
        }
        
        self.favoritedAvatarList = []
        AvatarAPI.getFavoritedAvatar(client: apiClient) { avatars in
            if let avatars = avatars {
                for item in avatars {
                    
                    let newAvatar: VRAvatar = VRAvatar(name: item.name, id: item.id, authorName: item.authorName, imageUrl: item.imageUrl, description: item.description, authorId: item.authorId, updated_at: item.updated_at)
                    
                    DispatchQueue.main.async {
                        
                        if newAvatar.updated_at != nil {
                            self.favoritedAvatarList?.append(newAvatar)
                        }
                        
                    }
                }
            } else {
                print("Error: Failed to retrieve avatars")
            }
        }
    }
    
    //
    // MARK: Favorite
    //
    
    func getFavoritesAsync() async {
        //TODO: avoid getting so many favorites. fetch each type separately
        let favorites = await FavoriteAPIAsync.getFavorites(client: apiClientAsync, n: 200)
        
        guard let favorites = favorites else { return }
        
        DispatchQueue.main.sync {
            self.favoritedWorldIdList = []
            self.favoritedAvatarIdList = []
            self.favoritedFriendIdList = []
            
            for favorite in favorites {
                switch favorite.type {
                case .avatar:
                    self.favoritedAvatarIdList?.append(favorite.favoriteId!)
                case .world:
                    self.favoritedWorldIdList?.append(favorite.favoriteId!)
                case .friend:
                    self.favoritedFriendIdList?.append(favorite.favoriteId!)
                default:
                    continue
                }
            }
        }
    }
    
    func getFavorites() {
        FavoriteAPI.getFavorites(client: apiClient, n: 200) { favorites in
            guard let favorites = favorites else { return }
            
            DispatchQueue.main.sync {
                self.favoritedWorldIdList = []
                self.favoritedAvatarIdList = []
                self.favoritedFriendIdList = []
            }
            
            DispatchQueue.main.async {
                for favorite in favorites {
                    switch favorite.type {
                    case .avatar:
                        self.favoritedAvatarIdList?.append(favorite.favoriteId!)
                    case .world:
                        self.favoritedWorldIdList?.append(favorite.favoriteId!)
                    case .friend:
                        self.favoritedFriendIdList?.append(favorite.favoriteId!)
                    default:
                        continue
                    }
                }
            }
        }
    }
    
    func addFavoriteAsync(type: FavoriteType, favoriteId: String, tags: [String]? = nil) async {
        let favorite = await FavoriteAPIAsync.addFavorite(client: apiClientAsync, type: type, favoriteId: favoriteId, tags: tags)
        
        guard favorite != nil else { return }
        
        await getFavoritesAsync()
        
        getWorlds()
    }
    
    func removeFavoriteAsync(favoriteId: String) async {
        let favorite = await FavoriteAPIAsync.removeFavorite(client: apiClientAsync, favoriteId: favoriteId)
        
        guard favorite != nil else { return }
        
        await getFavoritesAsync()
        
        getWorlds()
    }
    
    #if DEBUG
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
        
        client_preview.worldList = [worldExample, worldExample2, worldExample3]
        client_preview.avatarList = [avatarExample1, avatarExample2, avatarExample3]
        
        client_preview.favoritedWorldIdList = [worldExample.id!]
        
        return client_preview
    }
    #endif
}

func nothing() {
    
}
