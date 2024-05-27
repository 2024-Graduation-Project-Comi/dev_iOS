//
//  CallRecordsDB.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import Supabase

class CallRecordsDB: ObservableObject {

    static var shared = CallRecordsDB()
    @Published var data: [CallRecords]

    init() {
        self.data = []
    }
    let client = SupaClient.shared.setClient()

    func getData() async -> [CallRecords] {
        do {
            let datas: [CallRecords] = try await client
                .from("CallRecords")
                .select()
                .eq("user_id", value: 1)
                .execute()
                .value
            return datas
        } catch {
            print(error)
            return []
        }
    }

    func getData(id: Int) async -> [CallRecords] {
        do {
            print("supa call id : \(id)")
            let datas: [CallRecords] = try await client
                .from("CallRecords")
                .select()
                .eq("user_id", value: id)
                .execute()
                .value
            return datas
        } catch {
            print(error)
            return []
        }
    }

}
