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

    let client = SupabaseClient(supabaseURL: URL(string: "https://evurjcnsdykxdkwnlwub.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2dXJqY25zZHlreGRrd25sd3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMxNTk2MDIsImV4cCI6MjAyODczNTYwMn0.VgrdCMbT-uqJpth4WQm7jcGCg8EAaIBKQcg2D3Hf1vE")

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
