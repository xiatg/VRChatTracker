//
//  FriendTabView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/22/23.
//

import SwiftUI

struct FriendTabView: View {
    @ObservedObject var client: VRChatClient
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct FriendTabView_Previews: PreviewProvider {
    static var previews: some View {
        FriendTabView(client: VRChatClient.createPreview())
    }
}
