//
//  ContentView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/16/23.
//

import SwiftUI
import AuthenticationServices

struct ContentView: View {
    var body: some View {
        VStack {
            Button(action: signIn) {
                Text("Sign In")
            }
        }
        .padding()
    }
}

func signIn() {
    guard let authURL = URL(string: "https://vrchat.com/home/login") else { return }
    
    let session = ASWebAuthenticationSession(url: authURL, callbackURLScheme: "exampleauth")
    { callbackURL, error in
        print(callbackURL)
        print(error)
    }
    
    session.start()
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
