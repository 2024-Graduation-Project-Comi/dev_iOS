//
//  GeminiAPIViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/24/24.
//

import Foundation
import Alamofire

struct TerminateRequestData: Codable {
    var id: String
    var scores: [ChatAzureResponseData]?
}

struct GeminiResult: Codable {
    let result: [CallConvResult]
    let remainTime: Int
    let azureAverageScore: AzureAverageScore

    enum CodingKeys: String, CodingKey {
        case result
        case remainTime
        case azureAverageScore = "azure_avg_score"
    }
}

class GeminiAPIViewModel: ObservableObject {
    @Published var result: GeminiResult = GeminiResult(result: [], remainTime: 0, azureAverageScore: AzureAverageScore(accuracyScore: 0, pronunciationScore: 0, completenessScore: 0, fluencyScore: 0, prosodyScore: 0))

    func terminateChat(userID: Int, azureScore: [ChatAzureResponseData]?, completion: @escaping (Bool) -> Void) {
        let params: TerminateRequestData = TerminateRequestData(id: String(userID), scores: azureScore)
        let url = "http://211.216.233.107:91/gemini/terminate/\(userID)"
        AF.request(url, method: .delete, parameters: params)
            .validate()
            .responseDecodable(of: GeminiResult.self, queue: .main) { response in
            switch response.result {
            case .success(let data):
                self.result = data
                completion(true)

            case .failure(let error):
                print("Error: \(error)")
                completion(false)

            }
        }
//            .response { response in
//            switch response.result {
//            case .success:
//                DispatchQueue.main.async {
//                    completion(true)
//                }
//            case .failure(let error):
//                print("Error: \(error)")
//                DispatchQueue.main.async {
//                    completion(false)
//                }
//            }
//        }
    }
}
