//
//  Swift_Auth_BoilerplateApp.swift
//  Swift-Auth-Boilerplate
//
//  Created by Aidan Blancas on 8/6/24.
//

import SwiftUI
import Firebase
@main
struct Swift_Auth_BoilerplateApp: App {
    @StateObject var viewModel = AuthViewModel()
    //we are going to initialize this AuthViewModel with an environment object on our root view so it can be used throughout the entire app
    
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
