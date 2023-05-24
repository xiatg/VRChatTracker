//
//  AvatarDetailView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 3/3/23.
//

import SwiftUI

struct AvatarDetailView: View {
    
    // pre-stored data for no internet connection
    var avatar: VRAvatar = avatarExample2
    
    // date format change
    let dateFormatter = DateFormatter()
    
    var body: some View {
        ScrollView {
            // title
            Text(avatar.name!)
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 3.0)
                .foregroundColor(.white)
                .padding(.leading, 20)
            
            // author
            Text("By: \(avatar.authorName!)")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 15))
                .padding(.bottom, 8.0)
                .foregroundColor(.white)
                .padding(.leading, 22)
            
            // Image
            AsyncImage(url: URL(string: avatar.imageUrl!)) { image in
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
            .cornerRadius(20)
            .padding(.horizontal, 20)
            .padding(.bottom, 10)
            
            // Description
            Text("Description")
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.system(size: 30))
                .padding(.bottom, 8.0)
                .foregroundColor(.white)
                .padding(.leading, 20)
            
            // other status
            VStack{
                // Full description
                Text(avatar.description!)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Divider()
                // Author
                HStack{
                    Text("Author")
                    Spacer()
                    Text(avatar.authorName!)
                }
                Divider()
                // Last Updated
                HStack {
                    Text("Last Updated")
                    Spacer()
                    let formattedDateString = formatDate(inputDate: avatar.updated_at ?? "2022-10-13T00:40:35.490Z")
                    Text(formattedDateString)
                }
            }
            .padding(.horizontal, 25)
            .foregroundColor(.white)
            .padding(.bottom, 15)
        }
        .background(Color("BackgroundColor"))
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
}

struct AvatarDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let avatar: VRAvatar = avatarExample3
        AvatarDetailView(avatar: avatar)
    }
}
