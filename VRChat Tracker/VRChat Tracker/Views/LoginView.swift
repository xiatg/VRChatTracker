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
        ZStack {
            Color("BackgroundColor")
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
                Button(action: {
                    signIn(username: username, password: password)
                }) {
                    HStack {
                        Spacer()
                        Text("Sign In")
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .contentShape(Rectangle())
                .padding(.bottom, 5)
                Button(action: {
                    // FIXME: should navigate to another view for users to sign up an account
                    signIn(username: username, password: password)
                }) {
                    HStack {
                        Spacer()
                        Text("Sign Up")
                            .foregroundColor(.red)
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .contentShape(Rectangle())
            }
            .padding(.all, 30.0)
        }
    }
}

func signIn(username: String, password: String){
    //FIXME: should check urnm & pswd using API
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
