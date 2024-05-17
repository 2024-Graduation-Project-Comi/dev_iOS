//
//  ModelsDB.swift
//  Comi
//
//  Created by yimkeul on 5/10/24.
//

import Foundation
import Supabase

class ModelsDB: ObservableObject {

    static var shared = ModelsDB()
    @Published var data: [Models]

    init() {
        self.data = []
    }

    let client = SupaClient.shared.setClient()

    func getData() async -> [Models] {
        do {
            let datas: [Models] = try await client
                .from("Models")
                .select()
                .execute()
                .value
            return datas
        } catch {
            print(error)
            return []
        }
    }
}
