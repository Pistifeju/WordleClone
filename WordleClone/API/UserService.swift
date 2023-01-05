//
//  UserService.swift
//  WordleClone
//
//  Created by István Juhász on 2023. 01. 03..
//

import FirebaseFirestore
import FirebaseAuth

struct UserService {
    
    public static let shared = UserService()
    private init() {}
    private let db = Firestore.firestore()
    
    /// A method to upload the game for the current user.
    /// - Parameters:
    ///   - user: The logged in user.
    ///   - completion: An optional error from firebase.
    public func uploadGame(user: User, completion: @escaping(Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("users").document(uid)
        ref.updateData([
            "losses": user.stats.losses,
            "wins": user.stats.wins,
            "streak": user.stats.streak,
            "maxStreak": user.stats.maxStreak,
        ]) { error in
            completion(error)
        }
    }
    
    public func fetchAllUsers(completion: @escaping([User]?, Error?) -> Void) {
        var users = [User]()
        
        db.collection("users").getDocuments { snapshot, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach { document in
                let user = User(dictionary: document.data())
                users.append(user)
            }
            
            completion(users, nil)
        }
    }
}
