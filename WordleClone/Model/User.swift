//
//  User.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

struct User {
    let username: String
    let email: String
    var userUID: String
    
    init(dictionary: [String: Any], withUID UID: String) {
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.userUID = UID
    }
}


struct UserStats {
    var winw: Int
    var losses: Int
    let posts: Int
}
