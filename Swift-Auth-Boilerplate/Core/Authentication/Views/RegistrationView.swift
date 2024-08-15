//
//  RegistrationView.swift
//  Swift-Auth-Boilerplate
//
//  Created by Aidan Blancas on 8/7/24.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Image("fb")
                .resizable()
                .scaledToFill()
                .frame(width:100, height:120)
            .padding(.vertical, 32)
            
            
            VStack(spacing:24){
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@exmaple.com")
                .autocapitalization(.none) // no auto caps for email field
                
                InputView(text: $fullname,
                          title:"Full name",
                          placeholder:"Enter your full name")
                
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter your password",
                          isSecureField: true)
                .autocapitalization(.none)
                
                ZStack(alignment: .trailing){
                    InputView(text: $confirmPassword,
                              title:"Confirm Password",
                              placeholder:"Confirm your password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty { // getting around the image being shown with 2 nil texts
                        if password == confirmPassword{
                            Image(systemName:"checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.systemGreen))
                        } else {
                            Image(systemName:"checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // sign in button
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email,
                                                   password: password,
                                                   fullname: fullname)
                }
            } label: {
                HStack{
                    Text("Sign up")
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
            
            Button{
                dismiss()
            } label: {
                HStack(spacing:3){
                    Text("Already have an account?")
                    Text("Sign in")
                        .fontWeight(.bold)
                        
                }
                .font(.system(size:14))
            }
        }
    }
}


//extenstion for form validity
extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password 
        && !fullname.isEmpty
        
    }
}

#Preview {
    RegistrationView()
}
