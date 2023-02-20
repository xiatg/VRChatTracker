//
//  ContentView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/16/23.
//

import SwiftUI
import AuthenticationServices

struct LoginView: View {
    
    @State var username = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundColor(.white)
                .bold()
            Image("welcome")
                .resizable()
                .frame(height: 180)
                .padding(.bottom, 10)
            Text("Hey there! I've been tapping my foot and checking my watch, waiting for you to show up. ")
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .font(.body)
                .padding(.bottom, 30)
            Text("Login now to explore our features!")
                .foregroundColor(.white)
                .bold()
                .padding(.bottom, 20)
            TextField("Username", text: $username)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .padding(.bottom, 5)
            TextField("Password", text: $password)
                .padding()
                .background(Color.white)
                .cornerRadius(5)
                .padding(.bottom, 15)
            Button("Sign In") {
                signIn(username: username, password: password)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .background(Color.white.opacity(0.5))
            .cornerRadius(15)
        }
        .padding(.all, 30.0)
        .background(Color("BackgroundColor"))
    }
}

func signIn(username: String, password: String){
    if username == "123" && password == "123" {
        print("login successful")
    }
    else {
        print("login failed")
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
