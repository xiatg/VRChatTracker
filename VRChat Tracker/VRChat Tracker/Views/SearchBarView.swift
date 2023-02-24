//
//  SearchBarView.swift
//  VRChat Tracker
//
//  Created by Jintao Hu on 2/23/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var text: String
    
    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 10)
            Button(action: {
                withAnimation {
                    text = ""
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color(.systemGray3))
            }
        }
        .frame(height: 36)
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(text: .constant("Search"))
                    .previewLayout(.sizeThatFits)
                    .padding()
    }
}
