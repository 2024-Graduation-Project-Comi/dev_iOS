//
//  TopicsSet.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation

struct Topics: Codable, Hashable {
    let id: Int
    var title: String
    var koTitle: String = ""
    let desc: String

    enum CodingKeys: String, CodingKey {
        case id = "topic_id"
        case title, desc
    }
}
