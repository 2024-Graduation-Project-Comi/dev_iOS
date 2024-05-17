//
//  SupabaseInfo++Bundle.swift
//  Comi
//
//  Created by yimkeul on 5/17/24.
//

import Foundation
extension Bundle {
    var supaApiKey: String? {
        guard let file = self.path(forResource: "SupabaseInfo", ofType: "plist") else { return nil}

        guard let resource = NSDictionary(contentsOfFile: file) else { return nil }
        guard let key = resource["API_KEY"] as? String else { fatalError("SupabaseInfo.plist에 API_KEY 설정을 해주세요.")}
        return key
    }

    var supaURL: String? {
        guard let file = self.path(forResource: "SupabaseInfo", ofType: "plist") else { return nil}

        guard let resource = NSDictionary(contentsOfFile: file) else { return nil }
        guard let key = resource["URL"] as? String else { fatalError("SupabaseInfo.plist에 URL 설정을 해주세요.")}
        return key
    }
}
