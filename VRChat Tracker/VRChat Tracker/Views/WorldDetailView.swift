//
//  WorldDetailView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import SwiftUI

struct WorldDetailView: View {
    
    var world: VRWorld = worldExample
    let dateFormatter = DateFormatter()
    
    var body: some View {
        
        ScrollView {
            // title
            Text(world.name!)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 40))
                .padding(.bottom, 3.0)
                .foregroundColor(.white)
                .padding(.leading, 20)
            
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
            } placeholder: {
                // placeholder while the image is loading
                Image("cat")
                    .resizable()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .scaledToFit()
            }
            .padding(.horizontal, 20)
            
            // descriptions
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 30))
                .padding(.bottom, 8.0)
                .foregroundColor(.white)
                .padding(.leading, 20)
            Text(world.description!)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 15))
                .padding(.bottom, 8.0)
                .foregroundColor(.white)
                .padding(.leading, 20)
            
            // other status
            VStack{
                HStack{
                    Text("Visits")
                    Spacer()
                    Text("\(Int(world.visits!))")
                }
                Divider()
                HStack {
                    Text("Favorites")
                    Spacer()
                    Text("\(Int(world.favorites!))")
                }
                Divider()
                HStack {
                    Text("Capacity")
                    Spacer()
                    Text("\(Int(world.capacity!))")
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
            
            // favorite button
            Button(action: addOrDelFavorite) {
                HStack {
                    Spacer()
                    Image(systemName: "star.fill")
                        .id(123)
                    Text("Add to Favorites")
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(15)
            .contentShape(Rectangle())
            .padding(.horizontal, 20)
        }
        .background(Color("BackgroundColor"))
        
    }
    
    func formatDate(inputDate: String) -> String {
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: inputDate)
        dateFormatter.dateFormat = "MMM d, yyyy"
        let result = dateFormatter.string(from: date!)
        return result
    }
    
    func addOrDelFavorite() {
        // TODO: add this world into favorite list or remove it from my list
        return
    }
    
}

struct WorldDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let world = worldExample
        WorldDetailView(world: world)
    }
}
