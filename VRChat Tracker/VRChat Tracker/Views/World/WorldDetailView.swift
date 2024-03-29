//
//  WorldDetailView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import SwiftUI
import SwiftVRChatAPI

struct WorldDetailView: View {
    
    // the world instance to pass in
    @State var world: VRWorld
    
    // the observable VRChat cilent instance
    @ObservedObject var client: VRChatClient
    
    @State var isFavorited: Bool
    
    @Environment(\.isLoading) @Binding var isLoading: Bool
    
    // the data format
    let dateFormatter = DateFormatter()
    
    init(world: VRWorld, client: VRChatClient) {
        self.world = world
        self.client = client
        
        self._isFavorited = State(initialValue: client.favoritedWorldIdList!.contains(world.id!))
    }
    
    var body: some View {
        // fetch world list data from the API
        let world = world
        NavigationStack {
            ScrollView {
                // title
                Text(world.name!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.largeTitle)
                    .padding(.bottom, 3.0)
                    .foregroundColor(.white)
                    .padding(.leading, 20)
                    .bold()
                
                // author
                Text("By: \(world.authorName!)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.system(size: 15))
                    .padding(.bottom, 8.0)
                    .foregroundColor(.white)
                    .padding(.leading, 22)
                
                // Image
                AsyncImage(url: URL(string: world.imageUrl!)) { image in
                    image
                        .resizable()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scaledToFit()
                        .cornerRadius(15)
                } placeholder: {
                    // placeholder while the image is loading
                    Image("cat")
                        .resizable()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .scaledToFit()
                        .cornerRadius(15)
                }
                .padding(.horizontal, 20)
                
                // favorite button
                Button {
                    Task {
                        isLoading = true
                        await addOrDelFavorite(favoriteId: world.id!)
                        isLoading = false
                    }
                } label: {
                    HStack {
                        Spacer()
                        if (isFavorited) {
                            Image(systemName: "star.fill")
                                .id(123)
                            Text("Favorited")
                            Spacer()
                        } else {
                            Image(systemName: "star")
                                .id(123)
                            Text("Add to Favorites")
                            Spacer()
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .contentShape(Rectangle())
                .padding(.horizontal, 20)
                
                if let description = world.description {
                    Text(description.replacingOccurrences(of: "⁄", with: "/").replacingOccurrences(of: "＃", with: "#").replacingOccurrences(of: "˸", with: ":").replacingOccurrences(of: "（", with: "(").replacingOccurrences(of: "）", with: ")").replacingOccurrences(of: "∗", with: "*").replacingOccurrences(of: "＂", with: "\""))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 15))
                        .padding(.bottom, 8.0)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                } else {
                    Text("please refresh to load description")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.system(size: 15))
                        .padding(.bottom, 8.0)
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                }
                
                // other status
                VStack{
                    HStack{
                        Text("Visits")
                        Spacer()
                        let visits = world.visits ?? 1
                        Text("\(Int(visits))")
                    }
                    Divider()
                    HStack {
                        Text("Favorites")
                        Spacer()
                        let favorites = world.favorites ?? 1
                        Text("\(Int(favorites))")
                    }
                    Divider()
                    HStack {
                        Text("Capacity")
                        Spacer()
                        let capacity = world.capacity ?? 1
                        Text("\(Int(capacity))")
                    }
                    Divider()
                    HStack {
                        Text("Created")
                        Spacer()
                        let formattedDateString = formatDate(inputDate: world.created_at ?? "2022-10-13T00:40:35.490Z")
                        Text(formattedDateString)
                    }
                    Divider()
                    HStack {
                        Text("Last Updated")
                        Spacer()
                        let formattedDateString = formatDate(inputDate: world.updated_at ?? "2022-10-13T00:40:35.490Z")
                        Text(formattedDateString)
                    }
                }
                .padding(.horizontal, 25)
                .foregroundColor(.green)
                .padding(.bottom, 15)
                
                Spacer()
            }
            .background(Color("BackgroundColor"))
            .refreshable {
                Task {
                    if let world = await client.fetchWorldAsync(worldId: world.id!) {
                        self.world = world
                    }
                }
            }
            .onAppear {
                Task {
                    if let world = await client.fetchWorldAsync(worldId: world.id!) {
                        self.world = world
                    }
                }
            }
        }
    }
    
    /**
     Change the date format style.

     - Parameter inputDate: The date format to change.

     - Returns: the correct format of date = "MMM d, yyyy".
     */
    func formatDate(inputDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: inputDate)
        dateFormatter.dateFormat = "MMM d, yyyy"
        let result = dateFormatter.string(from: date!)
        return result
    }
    
    /**
     Add or delete a world to/from the user's favorite list
     
     This function is not supported by API, but it will be supported in the future.
     */
    func addOrDelFavorite(favoriteId: String) async {
        if (isFavorited) {
            await client.removeFavoriteAsync(favoriteId: favoriteId)
        } else {
            await client.addFavoriteAsync(type: .world, favoriteId: favoriteId)
        }
        
        isFavorited.toggle()
    }
    
}

#if DEBUG
struct WorldDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let world = worldExample
        WorldDetailView(world: world, client: VRChatClient.createPreview())
    }
}
#endif
