//
//  CallRecordsSet.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation

struct CallRecords: Codable, Hashable {
    let callId: Int
    let userId: Int
    let modelId: Int
    let topic: String
    let convCnt: Int?
    let ended: Date
    let times: Int

    enum CodingKeys: String, CodingKey {
        case callId = "call_id"
        case userId = "user_id"
        case modelId = "model_id"
        case convCnt = "conv_count"
        case topic, ended, times
    }
}
