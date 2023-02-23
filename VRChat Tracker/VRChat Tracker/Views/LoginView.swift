//
//  ContentView.swift
//  VRChat Tracker
//
//  Created by 夏同光 on 2/16/23.
//

import SwiftUI
import SwiftVRChatAPI

struct LoginView: View {
    
    @ObservedObject var client: VRChatClient
    @State var username = ""
    @State var password = ""
    @State var twoFactorEmailCode = ""
    @State private var isLoading = false
    
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
                
                VStack {
                    if (client.is2FA == false) {
                        TextField("", text: $username)
                            .placeholder(when: username.isEmpty) {
                                Text("Username").foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .tint(.blue)
                            .cornerRadius(5)
                            .padding(.bottom, 5)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        SecureField("", text: $password)
                            .placeholder(when: password.isEmpty) {
                                Text("Password").foregroundColor(.black)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom, 15)
                    } else {
                        TextField("Two-factor Email Code", text: $twoFactorEmailCode)
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom, 5)
                            .transition(.move(edge: .trailing))
                    }
                }
                .foregroundColor(.black)
            
                
                Button(action: login) {
                    HStack {
                        Spacer()
                        if (isLoading) {
                            ProgressView()
                        } else {
                            if (client.is2FA) {
                                Text("Send 2FA Code")
                            } else {
                                Text("Sign In")
                            }
                        }
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white.opacity(0.5))
                .cornerRadius(15)
                .contentShape(Rectangle())
                .padding(.bottom, 5)
                
                if (client.is2FA == false) {
                    Button(action: nothing) { // FIXME: should jump to signup website in a browser
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
            }
            .padding(.all, 30.0)
        }
        .ignoresSafeArea()
    }
    
    func login(){
        
        isLoading = true
        
        if (client.is2FA == false) {
            client.apiClient = APIClient(username: username, password: password)
            client.userInfo = AuthenticationAPI(client: client.apiClient!).loginUserInfo()
        } else {
            if AuthenticationAPI(client: client.apiClient!).verify2FAEmail(emailOTP: twoFactorEmailCode) ?? false {
                client.userInfo = AuthenticationAPI(client: client.apiClient!).loginUserInfo()
            }
        }
        
        if (client.userInfo?.requiresTwoFactorAuth == ["emailOtp"]) {
            client.is2FA = true
        } else {
            if (client.userInfo?.displayName != nil) {
                client.isLoggedIn = true
                client.is2FA = false
            }
        }
        
        print(client.isLoggedIn)
        print(client.is2FA)
        print(client.userInfo)
        print(client.apiClient?.cookies)
        
        isLoading = false
    }
}

// https://stackoverflow.com/questions/57688242/swiftui-how-to-change-the-placeholder-color-of-the-textfield
extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(client: VRChatClient())
    }
}
