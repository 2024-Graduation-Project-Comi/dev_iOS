//
//  Users.swift
//  Comi
//
//  Created by yimkeul on 5/28/24.
//

import Foundation

struct Users: Codable, Hashable {
    let userId: Int
    let createdAt: String
    var email: String
    let social: String
    let remainTime: Int

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case createdAt = "created_at"
        case remainTime = "remain_time"
        case email, social
    }
}
