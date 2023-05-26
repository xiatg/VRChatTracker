//
//  BioLinkView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 5/23/23.
//

import SwiftUI

struct BioLinkView: View {
    
    var bioLink: String
    
    var body: some View {
        Button(action: {}) {
            if (bioLink.hasPrefix("https://pixiv") || bioLink.hasPrefix("https://www.pixiv")) {
                Image("pixiv")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            } else if (bioLink.hasPrefix("https://discord") || bioLink.hasPrefix("https://www.discord")) {
                Image("discord")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            } else if (bioLink.hasPrefix("https://github") || bioLink.hasPrefix("https://www.github")) {
                Image("github")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            } else if (bioLink.hasPrefix("https://twitter") || bioLink.hasPrefix("https://www.twitter")) {
                Image("twitter")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            } else if (bioLink.hasPrefix("https://instagram") || bioLink.hasPrefix("https://www.instagram")) {
                Image("instagram")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            } else {
                Image(systemName: "link")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20, height: 20)
            }
        }
        .buttonStyle(.bordered)
        .clipShape(Circle())
    }
}

struct BioLinkView_Previews: PreviewProvider {
    static var previews: some View {
        BioLinkView(bioLink: "https://twitter.gg")
    }
}
