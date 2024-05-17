//
//  TopicsDB.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import Supabase

class TopicsDB: ObservableObject {

    static var shared = TopicsDB()
    @Published var data: [Topics]

    init() {
        self.data = []
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
            } catch {
                print(error)
            }
        }
    }
}
