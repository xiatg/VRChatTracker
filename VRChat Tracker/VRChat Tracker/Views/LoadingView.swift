//
//  LoadingView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 5/23/23.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        // Dim the progress view with a semi-transparent overlay
        Color.black.opacity(0.4)
            .edgesIgnoringSafeArea(.all)
        HStack {
            ProgressView()
                .progressViewStyle(.automatic)
                .tint(.white)
            Text("Loading...")
                .font(.title2)
                .foregroundColor(.white)
                .bold()
        }
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
