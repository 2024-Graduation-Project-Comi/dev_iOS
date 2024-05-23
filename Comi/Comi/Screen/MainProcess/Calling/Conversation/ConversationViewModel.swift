//
//  ConversationViewModel.swift
//  Comi
//
//  Created by 문영균 on 5/17/24.
//

import Foundation
import Alamofire
import AVFoundation

enum ResponseErrors: Error {
    case stringToDictionaryError
    case dictionaryToStructError
    case stringDecodeError
}

class CustomEventMonitor: EventMonitor {
    var streamHandler: ((Data) -> Void)?

    func requestDidResume(_ request: Request) {
            print("Request did resume: \(request)")
        }

    func requestDidComplete(_ request: Request) {
        print("Request did complete: \(request)")
    }

    func request(_ request: DataRequest, didParseResponse response: DataResponse<Data?, AFError>) {
        print("Request completed with response")
        switch response.result {
        case .success(let data):
            print("Request successful")
            if let data = data {
                streamHandler?(data)
            } else {
                print("Data is nil")
            }
        case .failure(let error):
            print("Error occurred during stream: \(error.localizedDescription)")
        }
    }
}

struct ChatResponseData: Codable, Hashable {
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

struct ChatRequestData: Codable {
    // id, topic을 제외하고 enum으로 만들어주어야 할지 고민
    let id: String
    let topic: String
    let conversationLanguage: String
    let explanationLanguage: String
    let model: String

    enum CodingKeys: String, CodingKey {
        case conversationLanguage = "conv_lan"
        case explanationLanguage = "ex_lan"
        case id, topic, model
    }
}

struct ConversationRequestData: Codable {
    let answer: String
    let id: String
    let conversationLanguage: String
    let model: String

    enum CodingKeys: String, CodingKey {
        case answer, id, model
        case conversationLanguage = "lan"
    }
}

class ConversationViewModel: ObservableObject {
    @Published var aiChat: String = ""
    @Published var userChat: String = ""
    @Published var responseData: ChatResponseData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var audioPlayer: AVAudioPlayer?
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

    private var session: Session!

    func startConversation2(chatRequestData: ChatRequestData, completion: @escaping (Result<ChatResponseData, Error>) -> Void) {
        let url = "http://211.216.233.107:91/gemini/create"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json, audio/wav"
        ]

        // EventMonitor를 사용하여 스트리밍 이벤트 처리
        let eventMonitor = CustomEventMonitor()
        eventMonitor.streamHandler = { data in
            print("Received stream data: \(data.count) bytes")
            self.processStreamData(data: data)
        }

        // Alamofire Session 구성
        self.session = Session(eventMonitors: [eventMonitor])

        self.session.streamRequest(url, method: .post, parameters: chatRequestData, encoder: JSONParameterEncoder.default, headers: headers)
            .responseStream { stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(data):
                        if let rawString = String(data: data, encoding: .utf8) { // stream data가 text로 들어오는 경우
                            print("Raw string: \(rawString)")
                            if let dicData = self.convertStringToDictionary(text: rawString) {
                                print("Converted string to dictionary: \(dicData)")
                                DispatchQueue.main.async {
                                    if let responseData = self.parseChatResponseData(from: dicData) {
                                        self.responseData = responseData
                                        self.aiChat = responseData.conv
                                        completion(.success(responseData))
                                    } else {
                                        print(self.errorMessage ?? "")
                                        self.errorMessage = "Failed to parse response data"
                                        completion(.failure(ResponseErrors.dictionaryToStructError))
                                    }
                                }
                            }
                        } else {
                            print("Stream data received: \(data.count) bytes.")
                            self.processStreamData(data: data)
                        }
                    case let .failure(error):
                        print("Error occurred during stream: \(error.localizedDescription)")
                    }
                case let .complete(complete):
                    print("Stream complete")
                }
            }
    }

    func startConversation(chatRequestData: ChatRequestData, completion: @escaping (Result<ChatResponseData, Error>) -> Void) {
        let url = "http://211.216.233.107:91/gemini/create"
        let parameters: [String: Any] = [
            "id": chatRequestData.id,
            "topic": chatRequestData.topic,
            "conv_lan": chatRequestData.conversationLanguage,
            "ex_lan": chatRequestData.explanationLanguage,
            "model": chatRequestData.model
        ]
        let headers: HTTPHeaders = ["Content-Type": "application/json"]

        // EventMonitor를 사용하여 스트리밍 이벤트 처리
        let eventMonitor = CustomEventMonitor()
        eventMonitor.streamHandler = { data in
            print("Received stream data: \(data.count) bytes")
            self.processStreamData(data: data)
        }

        // Alamofire Session 구성
        self.session = Session(eventMonitors: [eventMonitor])

        session.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
                    .responseData { response in
                        print("Response received")
                        switch response.result {
                        case .success(let data):
                            print("Response success with data: \(data.count) bytes")
                            // 서버 응답 데이터 출력
                            if let rawString = String(data: data, encoding: .utf8) {
                                print("Raw string: \(rawString)")
                                if let dicData = self.convertStringToDictionary(text: rawString) {
                                    print("Converted string to dictionary: \(dicData)")
                                    DispatchQueue.main.async {
                                        if let responseData = self.parseChatResponseData(from: dicData) {
                                            self.responseData = responseData
                                            self.aiChat = responseData.conv
                                            completion(.success(responseData))
                                        } else {
                                            print(self.errorMessage ?? "")
                                            self.errorMessage = "Failed to parse response data"
                                            completion(.failure(ResponseErrors.dictionaryToStructError))
                                        }
                                    }
                                }
//                                var dicData: Dictionary<String, Any> = [String: Any]()
//                                do {
//                                    dicData = try JSONSerialization.jsonObject(with: Data(rawString.utf8), options: []) as! [String : Any]
//                                    // 딕셔너리를 ChatResponseData 구조체로 변환
//                                    if let responseData = self.parseChatResponseData(from: dicData) {
//                                        self.responseData = responseData
//                                        completion(.success(responseData))
//                                    } else {
//                                        self.errorMessage = "Failed to parse response data"
//                                        completion(.failure(ResponseErrors.dictionaryToStructError))
//                                    }
//                                } catch {
//                                    print("딕셔너리화 에러: \(error.localizedDescription)")
//                                    completion(.failure(ResponseErrors.stringToDictionaryError))
//                                }
                            } else {
                                self.errorMessage = "Failed to decode response data"
                                completion(.failure(ResponseErrors.stringDecodeError))
                            }
                        case .failure(let error):
                            print("Error occurred: \(error)")
                            print(self.errorMessage ?? "")
                            completion(.failure(error))
                        }
                    }
    }

    func sendConversation(requestData: ConversationRequestData, completion: @escaping (Result<ChatResponseData, Error>) -> Void) {
        let url = "http://211.216.233.107:91/gemini/chat"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json, audio/wav"
        ]

        // EventMonitor를 사용하여 스트리밍 이벤트 처리
        let eventMonitor = CustomEventMonitor()
        eventMonitor.streamHandler = { data in
            print("Received stream data: \(data.count) bytes")
            self.processStreamData(data: data)
        }

        // Alamofire Session 구성
        self.session = Session(eventMonitors: [eventMonitor])
        self.session.streamRequest(url, method: .post, parameters: requestData, encoder: JSONParameterEncoder.default, headers: headers)
            .responseStream { stream in
                switch stream.event {
                case let .stream(result):
                    switch result {
                    case let .success(data):
                        if let rawString = String(data: data, encoding: .utf8) { // stream data가 text로 들어오는 경우
                            print("Raw string: \(rawString)")
                            if let dicData = self.convertStringToDictionary(text: rawString) {
                                print("Converted string to dictionary: \(dicData)")
                                DispatchQueue.main.async {
                                    if let responseData = self.parseChatResponseData(from: dicData) {
                                        self.responseData = responseData
                                        self.aiChat = responseData.conv
                                        completion(.success(responseData))
                                    } else {
                                        print(self.errorMessage ?? "")
                                        self.errorMessage = "Failed to parse response data"
                                        completion(.failure(ResponseErrors.dictionaryToStructError))
                                    }
                                }
                            }
                        } else {
                            print("Stream data received: \(data.count) bytes.")
                            self.processStreamData(data: data)
                        }
                    case let .failure(error):
                        print("Error occurred during stream: \(error.localizedDescription)")
                    }
                case let .complete(complete):
                    print("Stream complete")
                }
            }
    }

    private func processStreamData(data: Data) {
        print("Processing stream data: \(data.count) bytes")
        let chunkSize = 20
        var offset = 0

        while offset < data.count {
            let chunk = data.subdata(in: offset..<min(offset + chunkSize, data.count))
            print("Playing audio chunk of size: \(chunk.count) bytes")
            playAudioChunk(chunk)
            offset += chunkSize
        }
    }

    private func playAudioChunk(_ data: Data) {
        do {
            let player = try AVAudioPlayer(data: data)
            player.prepareToPlay()
            player.setVolume(1, fadeDuration: 0)
            player.play()
            self.audioPlayer = player
        } catch {
            print("Error occurred while trying to play audio: \(error.localizedDescription)")
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
