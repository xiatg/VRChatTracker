//
//  WorldTabView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import SwiftUI
import SwiftVRChatAPI

struct WorldTabView: View {
    
    // search bar text
    @State private var searchText = ""
    
    // the observable VRChat cilent instance
    @ObservedObject var client: VRChatClient
    
    var body: some View {
        
        NavigationStack {
            List {
                if let favoritedWorldList = client.favoritedWorldList {
                    Section("Favorited Worlds") {
                        WorldRowView(client: client, worlds: favoritedWorldList)
                    }
                }
                if let worldList = client.worldList {
                    Section("Discover Worlds") {
                        WorldRowView(client: client, worlds: worldList)
                    }
                }
            }
            .navigationTitle("Worlds")
        }
        .refreshable {
            client.getWorlds()
        }
        .onAppear {
            client.getWorlds()
        }
    }
}

struct WorldRowView: View {
    
    @ObservedObject var client: VRChatClient
    
    let worlds: [VRWorld]
    
    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack(spacing: 5) {
                ForEach(worlds.sorted{ ($0.popularity ?? 0) > ($1.popularity ?? 0) }) { world in
                    NavigationLink {
                        WorldDetailView(world: world, client: client)
                    } label: {
                        VStack {
                            HStack {
                                ZStack{
                                    // world image
                                    AsyncImage(url: URL(string: world.imageUrl ?? "")) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
//                                     rectangle for the use of UI design
                                    Rectangle()
                                        .frame(width: 300, height: 50.0)
                                        .offset(y: -90)
                                        .foregroundColor(Color("BackgroundColor"))
                                    HStack{
                                        // favorite button
                                        // not yet supported by API, but will be supported in the future
                                        Image(systemName: "star.fill")
                                            .foregroundColor(.yellow)
                                            .font(.system(size: 24))
                                            .offset(y: -5)
                                        VStack(alignment: .leading, spacing: 10) {
                                            Text(world.name ?? "😢")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .padding(.leading, 10.0)
                                                .cornerRadius(10)
                                            Text("By: \(world.authorName ?? "😢")")
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .font(.system(size: 12))
                                                .foregroundColor(.white)
                                                .fontWeight(.bold)
                                                .padding(.leading, 10.0)
                                                .cornerRadius(10)
                                                .offset(y: -10)
                                        }
                                    }
                                    .padding(EdgeInsets(top: 20, leading: 20, bottom: 2, trailing: 20))
                                    .offset(y: -95)
                                }
                            }
                        }
                        .cornerRadius(20)
                        .frame(width: 300, height: 250)
                        
                    }
                }
            }
        }
    }
}

#if DEBUG
struct WorldTabView_Previews: PreviewProvider {
    static var previews: some View {
//        let worldList = [worldExample, worldExample2, worldExample3]
//        WorldTabView(worldList: worldList)
        WorldTabView(client: VRChatClient.createPreview())
    }
}
#endif
