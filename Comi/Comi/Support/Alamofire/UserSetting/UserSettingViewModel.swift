//
//  UserSettingViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import Foundation
import Alamofire

class UserSettingViewModel: ObservableObject {

    func postInit(data: RealmSetting, completion: @escaping (Bool) -> Void) {
        let url = "http://211.216.233.107:88/user/init"
        let param: [String: Any] = [
            "user_id": data.userId,
            "proficiency_level": Int(data.level ?? 0),
            "learning_language": data.learning ?? "",
            "local_language": data.local
        ]

        AF.request(url, method: .post, parameters: param, encoding: JSONEncoding.default)
            .responseData { response in
            switch response.result {
            case .success:
                print("Post success \(response)")
                completion(true)
            case .failure:
                print("Post failure \(response) error")
            }
        }
    }

}
