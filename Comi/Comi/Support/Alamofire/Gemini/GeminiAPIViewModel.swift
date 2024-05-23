//
//  GeminiAPIViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/24/24.
//

import Foundation
import Alamofire

struct GeminiResult: Codable, Hashable {
    let result: [CallConvResult]
    let remainTime: Int
}

class GeminiAPIViewModel: ObservableObject {
    @Published var result:[GeminiResult] = []
    // MARK: 지우기
    func terminateChat(userID: Int) {
        print("테스트 중입니다 : ", userID)
    }
    
    func terminateChat(userID: Int, completion: @escaping (Bool) -> Void) {
        let param:[String:Any] = [
            "id": String(userID)
        ]
        let url = "http://211.216.233.107:91/gemini/terminate/{id}"
               AF.request(url, method: .delete, parameters: param)
                   .validate()
                   .response { response in
                       switch response.result {
                       case .success:
                           DispatchQueue.main.async {
                               completion(true)
                           }
                       case .failure(let error):
                           print("Error: \(error)")
                           DispatchQueue.main.async {
                               completion(false)
                           }
                       }
                   }
    }
}
