//
//  User.swift
//  WordleClone
//
//  Created by István Juhász on 2022. 12. 31..
//

struct User: Codable {
    let username: String
    let email: String
    var stats: UserStats = UserStats(wins: 0, losses: 0, streak: 0, maxStreak: 0)
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        self.stats.wins = dictionary["wins"] as? Int ?? 0
        self.stats.losses = dictionary["losses"] as? Int ?? 0
        self.stats.streak = dictionary["streak"] as? Int ?? 0
        self.stats.maxStreak = dictionary["maxStreak"] as? Int ?? 0
    }
}


struct UserStats: Codable {
    var wins: Int
    var losses: Int
    var streak: Int
    var maxStreak: Int
}
