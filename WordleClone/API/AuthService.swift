//
//  AuthService.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 30..
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class AuthService {
    
    public static let shared = AuthService()
    private init() {}
    private let db = Firestore.firestore()
    
    /// A method to register the user.
    /// - Parameters:
    ///   - userRequest: The users information (email, password, username)
    ///   - completion: A completion with two values (Bool, Error?)
    ///   - Bool: Determines if the user was registered and saved in the database correctly.
    ///   - Error?: An optional error if firebase provides one.
    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping(Bool, Error?) -> Void) {
        
        let username = userRequest.username
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(false, error)
                return
            }
            
            guard let resultUser = result?.user else {
                completion(false, nil)
                return
            }
            
            self.db.collection("users").document(resultUser.uid).setData([
                "username": username,
                "email": email
            ]) { error in
                if let error = error {
                    completion(false, error)
                    return
                }
                
                completion(true, nil)
            }
        }
    }
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping(Error?) -> Void) {
        
        let email = userRequest.email
        let password = userRequest.password
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
                completion(nil)
            }
        }
    }
    
    public func signOut(completion: @escaping(Error?) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
    
    public func forgotPassword(with email: String, completion: @escaping(Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
}
