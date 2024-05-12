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

    let client = SupabaseClient(supabaseURL: URL(string: "https://evurjcnsdykxdkwnlwub.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2dXJqY25zZHlreGRrd25sd3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMxNTk2MDIsImV4cCI6MjAyODczNTYwMn0.VgrdCMbT-uqJpth4WQm7jcGCg8EAaIBKQcg2D3Hf1vE")

    func getData() async -> [Topics] {
        do {
            let datas: [Topics] = try await client
                .from("Topics")
                .select()
                .execute()
                .value
            print("Get Topics : \(datas)")
            return datas
        } catch {
            print(error)
        }
        return []
    }
}
