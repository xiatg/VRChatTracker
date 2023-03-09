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
    
    // the stored metadata of three worlds
    // if the internet is disconnected, load the pre-stored data
    var worldExamples: [VRWorld] = [worldExample, worldExample2, worldExample3]
    
    var body: some View {
        // fetch world list data from the API
        let worldList = client.worldList?.isEmpty == false ? client.worldList! : worldExamples
        NavigationStack {
            // search bar to search avatars
            SearchBarView(text: $searchText)
                .padding([.leading, .trailing, .bottom], 16)
            // list all the world info
            List (worldList.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false })) { item in
                NavigationLink {
                    WorldDetailView(world: item, client: client)
                } label: {
                    ZStack{
                        // world image
                        AsyncImage(url: URL(string: item.imageUrl!)) { image in
                            image
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaledToFit()
                                .overlay {
                                    Rectangle().stroke(.black, lineWidth: 0.1)
                                }
                        } placeholder: {
                            // placeholder while the image is loading
                            Image("cat")
                                .resizable()
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .scaledToFit()
                                .overlay {
                                    Rectangle().stroke(.black, lineWidth: 0.1)
                                }
                        }
                        // rectangle for the use of UI design
                        Rectangle()
                            .frame(width: .infinity, height: 50.0)
                            .offset(y: -85)
                            .foregroundColor(.white)
                        HStack{
                            // favorite button
                            // not yet supported by API, but will be supported in the future
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.system(size: 24))
                                .offset(y: -5)
                            VStack(alignment: .leading, spacing: 10) {
                                Text(item.name ?? "😢")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .padding(.leading, 10.0)
                                    .cornerRadius(10)
                                Text("By: \(item.authorName ?? "😢")")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.system(size: 12))
                                    .foregroundColor(.blue)
                                    .fontWeight(.bold)
                                    .padding(.leading, 10.0)
                                    .cornerRadius(10)
                                    .offset(y: -10)
                            }
                        }
                        .padding(EdgeInsets(top: 20, leading: 20, bottom: 2, trailing: 20))
                        .offset(y: -90)
                    }
                    .id(item.id)
                    .cornerRadius(15)
                }
            }
            .navigationTitle("Discover Worlds")
        }
        .refreshable {
            client.getWorlds()
        }
    }
}

struct WorldTabView_Previews: PreviewProvider {
    static var previews: some View {
//        let worldList = [worldExample, worldExample2, worldExample3]
//        WorldTabView(worldList: worldList)
        WorldTabView(client: VRChatClient.createPreview())
    }
}
