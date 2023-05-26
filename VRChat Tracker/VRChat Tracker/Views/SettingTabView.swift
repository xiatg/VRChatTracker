//
//  SettingTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import SwiftUI

struct SettingTabView: View {
    @ObservedObject var client: VRChatClient
    @Environment(\.isLoading) @Binding var isLoading: Bool
    
    
    var body: some View {
        NavigationStack {
            List {
                // log out button
                Section(content: {
                    Button {
                        Task {
                            isLoading = true
                            await logout()
                            isLoading = false
                        }
                    } label: {
                        Text("Logout")
                    }
                }, header: {
                    Text("system")
                })
                
                Section(content: {
                    // the button link to our github code web page
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://github.com/watanabexia/VRChatTracker")!)
                    }, label: {
                        Text("Contribute on GitHub")
                    })
                    Button(action: nothing, label: {
                        Text("Support us ❤️")
                    })
                }, header: {
                    Text("about")
                })
            }
            .navigationTitle("Settings")
        }
    }
    
    /**
     Logout the current user, clean everything, go back to login page.
     */
    func logout() async {
        await client.logoutAsync()
        client.clear()
    }
}

struct SettingTabView_Previews: PreviewProvider {
    static var previews: some View {
        SettingTabView(client: VRChatClient.createPreview())
    }
}
