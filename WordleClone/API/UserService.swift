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
        guard let _ = Auth.auth().currentUser?.uid else { return }
                
        let ref = db.collection("users").document(user.userUID)
        ref.updateData([
            "losses": user.stats.losses,
            "wins": user.stats.wins,
            "streak": user.stats.streak,
            "maxStreak": user.stats.maxStreak,
        ]) { error in
            completion(error)
        }
    }
}
