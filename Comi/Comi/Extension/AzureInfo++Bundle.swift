//
//  Bundle+KEY.swift
//  Comi
//
//  Created by 문영균 on 5/17/24.
//

import Foundation

extension Bundle {
    var azureApiKey: String? {
        guard let file = self.path(forResource: "AzureInfo", ofType: "plist") else { return nil }
        guard let resource = NSDictionary(contentsOfFile: file) else { return nil }
        guard let key = resource["API_KEY"] as? String else { fatalError("AzureInfo.plist에 API_KEY 설정을 해주세요.") }
        return key
    }

    var azureRegion: String? {
        guard let file = self.path(forResource: "AzureInfo", ofType: "plist") else { return nil }
        guard let resource = NSDictionary(contentsOfFile: file) else { return nil }
        guard let key = resource["REGION"] as? String else { fatalError("AzureInfo.plist에 REGION 설정을 해주세요.") }
        return key
    }
}
