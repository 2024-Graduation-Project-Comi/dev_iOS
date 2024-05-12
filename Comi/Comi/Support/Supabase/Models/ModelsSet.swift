//
//  ModelsSet.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation

struct Models: Codable, Hashable {
    let id: Int
    let name: String
    var group: String?
    let state: ModelState
    let image: String

    enum CodingKeys: String, CodingKey {
        case id = "model_id"
        case name, group, state, image
    }
}

enum ModelState: Int, Codable {
    case available = 0
    case unavailable = 1
    case locked = 2
}
