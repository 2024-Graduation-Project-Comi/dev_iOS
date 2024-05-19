//
//  ConversationViewModel.swift
//  Comi
//
//  Created by 문영균 on 5/17/24.
//

import Foundation
import Alamofire

enum ResponseErrors: Error {
    case stringToDictionaryError
    case dictionaryToStructError
    case stringDecodeError
}

struct ChatResponseData: Codable {
    let conv: String
    let explain: String
    let eval: [String]
    let fix: String?
    
    enum CodingKeys: String, CodingKey {
        case conv, explain, eval, fix
    }
    
    init(conv: String, explain: String, eval: [String], fix: String?) {
        self.conv = conv
        self.explain = explain
        self.eval = eval
        self.fix = fix
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        conv = try container.decode(String.self, forKey: .conv)
        explain = try container.decode(String.self, forKey: .explain)
        fix = try container.decodeIfPresent(String.self, forKey: .fix)

        // eval 필드 디코딩
        if let evalArray = try? container.decode([String].self, forKey: .eval) {
            eval = evalArray
        } else if let evalDict = try? container.decode([String: String].self, forKey: .eval) {
            eval = evalDict.sorted { $0.key < $1.key }.map { $0.value }
        } else {
            eval = []
        }
    }
}

struct ChatRequestData {
    // id, topic을 제외하고 enum으로 만들어주어야 할지 고민
    let id: String
    let topic: String
    let conversationLanguage: String
    let explanationLanguage: String
    let model: String
}

class ConversationViewModel: ObservableObject {
    @Published var aiChat: String = ""
    @Published var userChat: String = ""
    @Published var responseData: ChatResponseData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    let topicMapping: [String: String] = [
        "프리토킹": "free talking",
        "연애": "love",
        "시사": "actualities",
        "운동": "exercise",
        "일상생활": "daily",
        "비즈니스": "business"
    ]
    let modelMapping: [String: String] = [
        "카리나": "karina",
        "윈터": "winter"
    ]

    func startConversation(chatRequestData: ChatRequestData, completion: @escaping (Result<ChatResponseData, Error>) -> Void) {
        let url = "http://211.216.233.107:91/gemini/create"
        let parameters: [String: Any] = [
            "id": chatRequestData.id,
            "topic": chatRequestData.topic,
            "conv_lan": chatRequestData.conversationLanguage,
            "ex_lan": chatRequestData.explanationLanguage,
            "model": chatRequestData.model
        ]

        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: ["Content-Type": "application/json"])
                    .responseData { response in
                        switch response.result {
                        case .success(let data):
                            // 서버 응답 데이터 출력
                            if let rawString = String(data: data, encoding: .utf8) {
                                print("날것의 문장:\n\(rawString)")
                                var dicData: Dictionary<String, Any> = [String: Any]()
                                do {
                                    dicData = try JSONSerialization.jsonObject(with: Data(rawString.utf8), options: []) as! [String : Any]
                                    print("딕셔너리 데이터:\n\(dicData)")
                                    // 딕셔너리를 ChatResponseData 구조체로 변환
                                    if let responseData = self.parseChatResponseData(from: dicData) {
                                        self.responseData = responseData
                                        completion(.success(responseData))
                                    } else {
                                        self.errorMessage = "Failed to parse response data"
                                        completion(.failure(ResponseErrors.dictionaryToStructError))
                                    }
                                } catch {
                                    print("딕셔너리화 에러: \(error.localizedDescription)")
                                    completion(.failure(ResponseErrors.stringToDictionaryError))
                                }
                            } else {
                                self.errorMessage = "Failed to decode response data"
                                completion(.failure(ResponseErrors.stringDecodeError))
                            }
                        case .failure(let error):
                            print("Error occurred: \(error)")
                            completion(.failure(error))
                        }
                    }
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
