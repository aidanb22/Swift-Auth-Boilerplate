//
//  AuthViewModel.swift
//  Swift-Auth-Boilerplate
//
//  Created by Aidan Blancas on 8/9/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
@MainActor //we need to publish all UI updates on main thread so we add this.


protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}
//This will be responsible for a few things
//Having functionality with authenticating our user, in charge of updating the UI when needing to update
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User? //firebase auth user
    @Published var currentUser: User?               // our user model we
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    
    func signIn(withEmail email: String, password: String) async throws { //async throws means networking better than URL sessions.
        //whenver you call this function, it (might) need to be wrapped in a Task { try await
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser() //without this, the profile will just be blank with no fetched data for the User logging in. if not await,
        } catch {
            print("DEBUG: Failed to login with error \(error.localizedDescription)")
        }
        
    }
    
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user //object that comes back from result var.
            let user = User(id: result.user.uid, fullname: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser() //once we create user, we're gonna fetch this data so we can properly display it on profileview. 
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    
    func signOut() {
        //takes back to login screen
        //on backend, it needs to signout of the firebase server also.
        do {
            try Auth.auth().signOut() // sign user out on backend
            self.userSession = nil //wipes user session, will navigate to loginscreen thru presentation logic (contentview)
            self.currentUser = nil //wipes out current user data model 
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
        
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser()async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        //no need to handle error in this situation. optional try statement so we do have to add the GUARD
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        
    }
    
}
