//
//  SplashView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 3/8/23.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            VStack {
                VStack {
                    Text("VRChat Tracker")
                    Text("Developped with ❤️ by")
                    Text("Qingyang Xu & Jintao Hu")
                }
                .font(.title)
                .bold()
                
                
                
                Text("Tap to continue...")
            }
            
            .foregroundColor(.white)
            
            
        }
        .ignoresSafeArea()
        
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
