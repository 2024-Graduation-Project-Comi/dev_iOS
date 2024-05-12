//
//  SupaTest.swift
//  Comi
//
//  Created by yimkeul on 5/10/24.
//

import Foundation
import Supabase

class SupaViewModel {
    static var shared = SupaViewModel()
    
    let client = SupabaseClient(supabaseURL: URL(string: "https://evurjcnsdykxdkwnlwub.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2dXJqY25zZHlreGRrd25sd3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMxNTk2MDIsImV4cCI6MjAyODczNTYwMn0.VgrdCMbT-uqJpth4WQm7jcGCg8EAaIBKQcg2D3Hf1vE")
    
    func getModel() async {
        do {
            let datas: [sModels] = try await client
                .from("Models")
                .select()
                .execute()
                .value
            print(datas)
        } catch {
            print(error)
        }
    }
    
    func getModels() async -> [sModels] {
        do {
            let datas: [sModels] = try await client
                .from("Models")
                .select()
                .execute()
                .value
            return datas
        } catch {
            print(error)
        }
        return []
    }
}

struct sModels: Codable, Hashable {
    let id: Int
    let name: String
    var group: String?
    let state: smodelState
    let image: String
    enum CodingKeys: String, CodingKey {
        case id = "model_id"
        case name, group, state, image
    }
}


enum smodelState: Int, Codable {
    case available = 0
    case unavailable = 1
    case locked = 2
}
