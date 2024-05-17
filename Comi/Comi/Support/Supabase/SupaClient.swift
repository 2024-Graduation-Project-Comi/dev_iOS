//
//  SupaClient.swift
//  Comi
//
//  Created by yimkeul on 5/17/24.
//

import Foundation
import Supabase

class SupaClient: ObservableObject {

    static var shared = SupaClient()

    func getKey() -> String {
        guard let key = Bundle.main.supaApiKey else {
            print("Supabase Key 로드 실패")
            return ""
        }
        return key
    }

    func getUrl() -> String {
        guard let region = Bundle.main.supaURL else {
            print("Supabase Region 로드 실패")
            return ""
        }
        return region
    }

    func setClient() -> SupabaseClient {
        let url = URL(string:getUrl())!
        let key = getKey()
        let client = SupabaseClient(supabaseURL: url, supabaseKey: key)
        return client
    }
}
