//
//  WorldTabView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import SwiftUI

struct WorldTabView: View {
    
    // search bar text
    @State private var searchText = ""
    
    // FIXME: placeholder data
    var worldList: [VRWorld] = [worldExample, worldExample2, worldExample3]
    
    var body: some View {
        NavigationStack {
            SearchBarView(text: $searchText)
                .padding([.leading, .trailing, .bottom], 16)
            List (worldList.filter({ searchText.isEmpty ? true : $0.name?.localizedCaseInsensitiveContains(searchText) ?? false })) { item in
                NavigationLink {
                    WorldDetailView(world: item)
                } label: {
                    ZStack{
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
                        Rectangle()
                            .frame(width: .infinity, height: 50)
                            .offset(y: -85)
                            .foregroundColor(.white)
                        HStack{
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
                    .cornerRadius(15)
                }
            }
            .navigationTitle("Discover Worlds")
        }
    }
}

struct WorldTabView_Previews: PreviewProvider {
    static var previews: some View {
        let worldList = [worldExample, worldExample2, worldExample3]
        WorldTabView(worldList: worldList)
    }
}
