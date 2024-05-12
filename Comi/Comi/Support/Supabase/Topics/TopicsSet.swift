//
//  TopicsSet.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation

struct Topics: Codable, Hashable {
    let id: Int
    let title: String
    let desc: String

    enum CodingKeys: String, CodingKey {
        case id = "topic_id"
        case title, desc
    }
}
