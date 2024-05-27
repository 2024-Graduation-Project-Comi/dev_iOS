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
    let modelId: Int
    let callId: Int?
    let level: Int

    enum CodingKeys: String, CodingKey {
        case id, topic, model, level
        case conversationLanguage = "conv_lan"
        case explanationLanguage = "ex_lan"
        case modelId = "model_id"
        case callId = "call_id"
    }
}

struct ConversationRequestData: Codable {
    let answer: String
    let id: String
    let azureScore: [ChatAzureResponseData]

    enum CodingKeys: String, CodingKey {
        case answer, id
        case azureScore = "azure_score"
    }
}

class ConversationViewModel: ObservableObject {
    @Published var aiChat: String = ""
    @Published var userChat: String = ""
    @Published var responseData: ChatResponseData?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published var audioPlayer: AVAudioPlayer?

    private var session: Session!

    func startConversation(chatRequestData: ChatRequestData, retryCount: Int = 3, completion: @escaping (Result<ChatResponseData, Error>) -> Void) {
        let url = "http://211.216.233.107:91/gemini/create"
        let headers: HTTPHeaders = [
            "Content-Type": "application/json"
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
//                        print("data received: \(data.count) bytes.")
                        // 텍스트 또는 오디오 데이터 확인
                        if let rawString = String(data: data, encoding: .utf8) {
                            print("Received text data: \(rawString)")
                            if let dicData = self.convertStringToDictionary(text: rawString) {
                                DispatchQueue.main.async {
                                    if let responseData = self.parseChatResponseData(from: dicData) {
                                        self.responseData = responseData
                                        self.aiChat = responseData.conv
                                        completion(.success(responseData))
                                    } else {
                                        self.errorMessage = "Failed to parse response data"
                                        completion(.failure(ResponseErrors.dictionaryToStructError))
                                    }
                                }
                            } else {
                                print("Failed to convert string to dictionary")
                                self.startConversation(chatRequestData: chatRequestData, retryCount: retryCount - 1, completion: completion)
                            }
                        } else {
                            // 오디오 데이터인지 확인
                            if data.count > 12, data.prefix(4) == Data([0x52, 0x49, 0x46, 0x46]) && data[8..<12] == Data([0x57, 0x41, 0x56, 0x45]) {
                                print("WAV data received: \(data.count) bytes.")
                                self.processStreamData(data: data)
                            }
                        }
                    case let .failure(error):
                        print("Error occurred during stream: \(error.localizedDescription)")
                    }
                case .complete(_):
                    print("Create complete")
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
                        // 텍스트 또는 오디오 데이터 확인
                        if let rawString = String(data: data, encoding: .utf8) {
                            print("Received text data: \(rawString)")
                            if let dicData = self.convertStringToDictionary(text: rawString) {
                                DispatchQueue.main.async {
                                    if let responseData = self.parseChatResponseData(from: dicData) {
                                        self.responseData = responseData
                                        self.aiChat = responseData.conv
                                        completion(.success(responseData))
                                    } else {
                                        self.errorMessage = "Failed to parse response data"
                                        completion(.failure(ResponseErrors.dictionaryToStructError))
                                    }
                                }
                            }
                        } else {
                            // 오디오 데이터인지 확인
                            if data.count > 12, data.prefix(4) == Data([0x52, 0x49, 0x46, 0x46]) && data[8..<12] == Data([0x57, 0x41, 0x56, 0x45]) {
                                print("WAV data received: \(data.count) bytes.")
                                self.processStreamData(data: data)
                            }
                        }
                    case let .failure(error):
                        print("Error occurred during stream: \(error.localizedDescription)")
                        completion(.failure(error))
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
