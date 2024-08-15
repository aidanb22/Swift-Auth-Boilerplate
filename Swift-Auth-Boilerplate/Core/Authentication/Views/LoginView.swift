//
//  LoginView.swift
//  Swift-Auth-Boilerplate
//
//  Created by Aidan Blancas on 8/6/24.
//

import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        NavigationStack{
            VStack{
                // image
                Image("fb")
                    .resizable()
                    .scaledToFill()
                    .frame(width:100, height:120)
                    .padding(.vertical, 32)
                   
                
                //form fields
                VStack(spacing:24){
                    InputView(text: $email,
                              title: "Email Address",
                              placeholder: "name@exmaple.com")
                    .autocapitalization(.none) // no auto caps for email field
                    
                    InputView(text: $password, title:"Password", placeholder:"Enter your password", isSecureField: true)
                    
                }
                .padding(.horizontal)
                .padding(.top, 12)
                
                // sign in button
                Button {
                    Task {
                        try await viewModel.signIn(withEmail: email, password: password)
                    }
                    
                } label: {
                    HStack{
                        Text("Sign in")
                            .fontWeight(.semibold)
                        Image(systemName: "arrow.right")
                        
                    }
                    .frame(width: UIScreen.main.bounds.width - 32, height: 48)
                }
                .background(Color(.systemBlue))
                .disabled(!formIsValid)
                .opacity(formIsValid ? 1.0: 0.5)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .foregroundStyle(.white)
                .padding(.top, 24)
                        
                Spacer()
                
                NavigationLink {
                    RegistrationView()
                        .navigationBarBackButtonHidden(true)
                } label: {
                    HStack(spacing:3){
                        Text("Don't have an account?")
                        Text("Sign up")
                            .fontWeight(.bold)
                            
                    }
                    .font(.system(size:14))
                }
                
                }
            
                
                
                //sign up button
                
            }
        }
    }

//extenstion for form validity
extension LoginView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
    }
}

#Preview {
    LoginView()
}
