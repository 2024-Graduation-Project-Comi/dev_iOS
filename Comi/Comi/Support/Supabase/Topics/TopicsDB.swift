//
//  TopicsDB.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import SwiftUI
import Supabase

enum KoreanTopics: Int {
    case freeTalking = 0
    case dating
    case currentEvents
    case sports
    case dailyLife
    case business

    func description() -> String {
        switch self {
        case .freeTalking:
            return "프리 토킹"
        case .dating:
            return "연애"
        case .currentEvents:
            return "시사"
        case .sports:
            return "운동"
        case .dailyLife:
            return "일상생활"
        case .business:
            return "비즈니스"
        }
    }
}

class TopicsDB: ObservableObject {

    static var shared = TopicsDB()
    @Published var data: [Topics]
    @Published var kodata: [Topics]

    init() {
        self.data = []
        self.kodata = []
    }

    let client = SupaClient.shared.setClient()

    func getData() {
        Task {
            do {
                let datas: [Topics] = try await client
                    .from("Topics")
                    .select()
                    .execute()
                    .value

                let sorted = datas.sorted { $0.id > $1.id }
                self.data = sorted
                self.kodata = sorted

                for index in 0 ..< kodata.count {
                    kodata[index].title = KoreanTopics(rawValue: kodata[index].id)?.description() ?? ""
                }
                


            } catch {
                print(error)
            }
        }
    }
}
