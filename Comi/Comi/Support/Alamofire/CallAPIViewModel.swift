//
//  CallRecordViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/23/24.
//

import Foundation
import SwiftUI
import Alamofire

struct Conversation: Codable, Hashable {
    let role: String
    let parts: [Part]
}

struct Part: Codable, Hashable {
    let text: String
}

struct AzureScore: Codable, Hashable {
    let text: String
    let accuracy: Int
    let prosody: Int
    let pronunciation: Int
    let completeness: Int
    let fluency: Int
    enum CodingKeys: String, CodingKey {
        case accuracy = "Accuracy_score"
        case prosody = "Prosody_score"
        case pronunciation = "Pronunciation_score"
        case completeness = "Completeness_Score"
        case fluency = "Fluency_score"
        case text
    }
}

struct CallConvResult: Codable, Hashable {
    let convId: Int
    let createdAt: String
    let callId: Int
    let ended: String
    let conversation: [Conversation]
    let azureScore: [AzureScore]?
    enum CodingKeys: String, CodingKey {
        case convId = "conv_id"
        case createdAt = "created_at"
        case ended = "ended_date"
        case callId = "call_id"
        case azureScore = "azure_scores"
        case conversation
    }
}

enum Types {
    case ai
    case user
}

struct TestStruct: Hashable {
    let role: String
    let conv: String
    var fix: String?
}

class CallAPIViewModel: ObservableObject {

    @Published var convItems: [CallConvResult] = []
    @Published var totalTalk: [TestStruct] = []

    // MARK: get /call/conv
    func fetchConv(callId: String, completion: @escaping (Bool) -> Void) {
        let url = "http://211.216.233.107:88/call/conv"
        let param: [String: Any] = [
            "call_id": callId,
            "page": 1,
            "limit": 9999
        ]
        AF.request(url, parameters: param)
            .validate()
            .responseDecodable(of: [CallConvResult].self) { response in
            switch response.result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.convItems = items
                    if let allData = self.convItems.first {
                        let data: [TestStruct] = allData.conversation.flatMap { datas in
                            if datas.role == "model" {
                                return datas.parts.compactMap { part in
                                    if let dics = self.convertStringToDictionary(text: part.text),
                                        let chats = self.parseChatResponseData(from: dics) {
                                        return TestStruct(role: "model", conv: chats.conv, fix: chats.fix)
                                    }
                                    return nil
                                }
                            } else {
                                return datas.parts.compactMap { part in
                                    return TestStruct(role: "user", conv: part.text, fix: nil)
                                }
                            }
                        }
                        self.totalTalk = Array(data.dropFirst())
                        for i in 1 ..< self.totalTalk.count {
                            self.totalTalk[i - 1].fix = self.totalTalk[i].fix
                            self.totalTalk[i].fix = nil
                        }
                    }
                    completion(true)
                }
            case .failure(let error):
                print("Error: \(error)")
                completion(false)
            }
        }
    }

    private func convertStringToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print("Error converting string to dictionary: \(error.localizedDescription)")
            }
        }
        return nil
    }

    private func parseChatResponseData(from dictionary: [String: Any]) -> ChatResponseData? {
        guard
            let conv = dictionary["conv"] as? String,
            let explain = dictionary["explain"] as? String else { return nil }

        // eval 필드 처리
        var evalArray: [String] = []
        if let eval = dictionary["eval"] as? [String: String] {
            evalArray = eval.sorted { $0.key < $1.key }.map { $0.value }
        } else if let eval = dictionary["eval"] as? [String] {
            evalArray = eval
        }

        let fix = dictionary["fix"] as? String

        return ChatResponseData(conv: conv, explain: explain, eval: evalArray, fix: fix)
    }
}
