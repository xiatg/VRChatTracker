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
    @State private var showPassword = false
    
    var body: some View {
        ZStack {
            Color("BackgroundColor")
            VStack {
                // Welcome Title
                Text("Welcome!")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.white)
                    .bold()
                // Welcome Image
                Image("welcome")
                    .resizable()
                    .frame(height: 180)
                    .padding(.bottom, 10)
                // Welcome message
                Text("Hey there! I've been tapping my foot and checking my watch, waiting for you to show up. ")
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .font(.body)
                    .padding(.bottom, 30)
                // Login Hint
                Text("Login now to explore our features!")
                    .foregroundColor(.white)
                    .bold()
                    .padding(.bottom, 20)
                // Login functionality
                VStack {
                    // MFA Check
                    if (client.is2FA == false) {
                        TextField("", text: $username, prompt: Text("Username").foregroundColor(.gray))
                            .padding()
                            .background(.white)
                            .tint(.blue)
                            .cornerRadius(5)
                            .padding(.bottom, 5)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                        
                        HStack {
                            if (showPassword) {
                                TextField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(5)
                                    .padding(.bottom, 15)
                            } else {
                                SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(5)
                                    .padding(.bottom, 15)
                            }
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash" : "eye")
                                    .foregroundColor(.white)
                                    .padding(.bottom)
                            }
                        }
                    } else {
                        // If username and password are correct, prompt to MFA check
                        TextField("", text: $twoFactorEmailCode, prompt: Text("Two-factor Email Code").foregroundColor(.gray))
                            .padding()
                            .background(Color.white)
                            .cornerRadius(5)
                            .padding(.bottom, 5)
                            .transition(.move(edge: .trailing))
                    }
                }
                .foregroundColor(.black)
                // login button
                Button {
                    Task {
                        await login()
                    }
                } label: {
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
                // if MFA check failed, cancel login action
                if (client.is2FA == false) {
                    Button(action: {
                        UIApplication.shared.open(URL(string: "https://vrchat.com/home/register")!)
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
                } else {
                    Button(action: cancel) {
                        HStack {
                            Spacer()
                            Text("Cancel")
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
            .padding([.leading, .bottom, .trailing], 30.0)
            .onTapGesture {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }
            
            if (client.isAutoLoggingIn || isLoading) {
                LoadingView()
            }
        }
        .alert(isPresented: $client.showNoInternetAlert) {
            Alert(title: Text("No Internet Connection"),
                  message: Text("Connect to the internet and try again."),
                  dismissButton: .default(Text("Okay")))
        }
        .alert(isPresented: $client.showErrorMessage) {
            Alert(title: Text("Login failed"),
                  message: Text(client.errorMessage),
                  dismissButton: .default(Text("Okay")))
        }
        .ignoresSafeArea()
    }
    /**
     Check MFA, if it passed, log the user in, else initialize a new login page.
     */
    func login() async {
        isLoading = true

        if (client.is2FA == false) {
            // initlaize a new `APIClient`
            client.apiClient = APIClient(username: username, password: password)
            client.apiClientAsync = APIClientAsync(username: username, password: password)
            
            await client.loginUserInfoAsync()
            
        } else {
            
            await client.email2FALoginAsync(emailOTP: twoFactorEmailCode)
        }
        
        isLoading = false
    }
    
    /**
     Cancel user login action, clean everything.
     */
    func cancel() {
        client.clear()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(client: VRChatClient())
    }
}
