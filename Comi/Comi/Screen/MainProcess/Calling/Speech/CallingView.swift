//
//  CallingView.swift
//  Comi
//
//  Created by yimkeul on 5/4/24.
//
var totalTime: Double = 0

import SwiftUI
import Kingfisher
import Combine

enum CallState {
    case ready
    case ai
    case wait
    case user
}

struct CallingView: View {
    @EnvironmentObject var realmViewModel: RealmViewModel
    @State private var background: CallState = .ready
    @State private var gotoFeedback: Bool = false
    @State var response: ChatResponseData?
    @StateObject private var speechViewModel = SpeechViewModel()
    @StateObject private var conversationViewModel = ConversationViewModel()
    @StateObject private var geminiAPIViewModel = GeminiAPIViewModel()
    @StateObject private var audioCaptureViewModel = AudioCaptureViewModel()
    @Binding var gotoRoot: Bool
    @State var isUserSpeaking = false
    @State var userSpeechedText = ""

    var topicTitle: String
    var model: RealmModel
    let callId: Int?
    let speechClient = SpeechPlayingClient()
    let ttsUrl = URL(string: "http://211.216.233.107:90/tts/tts_stream_chunk_static")!
    var azureDatas: ChatAzureResponseData?

    var body: some View {
        VStack {
            callInterface(modelData: model, topicData: topicTitle)
            Spacer()
            // TODO: 영균 기능 합치고 텍스트
            VStack {
                HStack {
                    VStack { // AI 대화창
                        if response != nil && isUserSpeaking == true {
                            Text(response?.conv ?? "")
                            Spacer()
                            Text("음성을 입력해주세요!")
                                .padding(.bottom, 10)
                        } else {
                            Text("채팅 생성을 기다리는 중이에요...")
                        }
                    }
                    VStack { // User 대화창

                    }
                }
            }
            Spacer()
            Divider()
            VStack {
                Text(speechViewModel.speechedText ?? "Say it!!")
                Button {
                    if speechViewModel.isRecording {
                        speechViewModel.stopRecording()
                    } else {
                        speechViewModel.startRecording()
                    }
                } label: {
                    Text(speechViewModel.isRecording ? "Stop Recording" : "Start Recording")
                }
                    .padding()

                Button {
                    if speechViewModel.isRecording {
                        speechViewModel.stopRecording()
                    } else {
                        speechViewModel.pronEvalBuiltIn { recognizedText in
                            userSpeechedText = recognizedText ?? ""
                        }
                    }
                } label: {
                    Text(speechViewModel.isRecording ? "Stop Recording" : "Pronunciation evaluation internal")
                }
                    .padding()

                Button {
                    if speechViewModel.isRecording {
                        speechViewModel.stopRecording()
                    } else {
                        speechViewModel.pronEval()
                    }
                } label: {
                    Text(speechViewModel.isRecording ? "Stop Recording" : "Pronunciation evaluation azure")
                }
                    .padding()

                Button {
                    let requestData = ConversationRequestData(answer: speechViewModel.speechedText ?? "", id: String(realmViewModel.userData.models.userId))
                    conversationViewModel.sendConversation(requestData: requestData) { result in
                        switch result {
                        case .success(let responseData):
                            print("Conversation: \(responseData.conv)")
                            print("Explanation: \(responseData.explain)")
                            print("Evaluation: \(responseData.eval)")
                            print("Fix: \(String(describing: responseData.fix))")
                            response = responseData

                            let requestParams = ["text": responseData.conv, "model": model.englishName, "language": realmViewModel.settingData.models.globalCode] as Dictionary
                            audioCaptureViewModel.playAiAudio(url: ttsUrl, params: requestParams) { _ in
                                isUserSpeaking = true
                            }
                        case .failure(let error):
                            print("Error occurred: \(error)")
                        }
                    }
                } label: {
                    Text("send next conversation.")
                }
            }
        }
            .padding(.horizontal, 24)
            .background(CallBackground(status: $background))
            .onAppear {
            let createConversationRequest: ChatRequestData = ChatRequestData(id: String(realmViewModel.userData.models.userId),
                                                                             topic: topicTitle,
                                                                             conversationLanguage: realmViewModel.settingData.models.globalCode,
                                                                             explanationLanguage: realmViewModel.settingData.models.local,
                                                                             model: model.name,
                                                                             modelId: model.id,
                                                                             callId: callId,
                                                                             level: realmViewModel.settingData.models.level)
            conversationViewModel.startConversation(chatRequestData: createConversationRequest) { result in
                switch result {
                case .success(let responseData):
                    print("Conversation: \(responseData.conv)")
                    print("Explanation: \(responseData.explain)")
                    print("Evaluation: \(responseData.eval)")
                    print("Fix: \(String(describing: responseData.fix))")
                    DispatchQueue.main.async {
                        response = responseData
                    }
                    let requestParams = ["text": responseData.conv, "model": model.englishName, "language": realmViewModel.settingData.models.globalCode] as Dictionary
                    audioCaptureViewModel.playAiAudio(url: ttsUrl, params: requestParams) { _ in
                        DispatchQueue.main.async {
                            isUserSpeaking = true
                            speechViewModel.startRecording() // AI 음성이 끝나면 대화 시작하도록 함
                        }
                    }
                case .failure(let error):
                    print("Error occurred: \(error)")
                }
            }
        }
            .onReceive(speechViewModel.$isRecording) { isRecording in
            if !isRecording {
                // 녹음이 종료되었을 때 수행할 작업
                print("Recording stopped")
                speechViewModel.pronEvalBuiltIn { recognizedText in
                    print("Pronunciation evaluation internal")
                    let requestData = ConversationRequestData(answer: recognizedText ?? "", id: String(realmViewModel.userData.models.userId))
                    conversationViewModel.sendConversation(requestData: requestData) { result in
                        switch result {
                        case .success(let responseData):
                            print("Conversation: \(responseData.conv)")
                            print("Explanation: \(responseData.explain)")
                            print("Evaluation: \(responseData.eval)")
                            print("Fix: \(String(describing: responseData.fix))")
                            response = responseData

                            let requestParams = ["text": responseData.conv, "model": model.englishName, "language": realmViewModel.settingData.models.globalCode] as [String: Any]
                            audioCaptureViewModel.playAiAudio(url: ttsUrl, params: requestParams) { _ in
                                DispatchQueue.main.async {
                                    isUserSpeaking = true
                                }
                            }
                        case .failure(let error):
                            print("Error occurred: \(error)")
                        }
                    }
//                    print("Pronunciation evaluation internal")
//                    // 아래는 중복되는 로직이므로 캡슐화 하고싶다.
//                    let requestData = ConversationRequestData(answer: speechViewModel.speechedText ?? "", id: String(realmViewModel.userData.models.userId))
//                    conversationViewModel.sendConversation(requestData: requestData) { result in
//                        switch result {
//                        case .success(let responseData):
//                            print("Conversation: \(responseData.conv)")
//                            print("Explanation: \(responseData.explain)")
//                            print("Evaluation: \(responseData.eval)")
//                            print("Fix: \(String(describing: responseData.fix))")
//                            response = responseData
//
//                            let requestParams = ["text": responseData.conv, "model": model.englishName, "language": realmViewModel.settingData.models.globalCode] as Dictionary
//                            audioCaptureViewModel.playAiAudio(url: ttsUrl, params: requestParams) { _ in
//                                isUserSpeaking = true
//                            }
//                        case .failure(let error):
//                            print("Error occurred: \(error)")
//                        }
                }
                // 여기서 추가적인 로직을 실행할 수 있습니다.
            }
        }
    }

    @ViewBuilder
    private func callInterface(modelData: RealmModel, topicData: String) -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.cwhite)
                    .shadow(radius: 100, y: -100)

                VStack {
                    HStack(alignment: .center, spacing: 16) {
                        KFImage(URL(string: model.image))
                            .fade(duration: 0.25)
                            .startLoadingBeforeViewAppear(true)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 62, height: 62)
                            .clipShape(Circle())

                        Text(modelData.name)
                            .font(.ptSemiBold18)
                        Spacer()
                        Button {
//                            geminiAPIViewModel.terminateChat(userID: realmViewModel.userData.models.userId, completion: {
//                                result in
//                                if result {
//                                    gotoFeedback = true
//                                }
//                            })
                            geminiAPIViewModel.terminateChat(userID: realmViewModel.userData.models.userId)
                            gotoFeedback = true
                        } label: {
                            Image("Disconnected")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }.background(
                            // TODO: 영균이가 /gemini/terminate/{id} 호출시 나오는 데이터 전송
                            NavigationLink(
                                destination: FeedbackView(
                                    gotoRoot: $gotoRoot,
                                    targetCallID: "1020",
                                    model: modelData,
                                    topicData: topicData,
                                    intoRoute: "Calling"
                                )
                                    .navigationBarHidden(true),
                                isActive: $gotoFeedback,
                                label: { EmptyView() }
                            ))
                    }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)

                    ZStack {
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                        HStack(alignment: .center, spacing: 8) {
                            Text("언어")
                                .font(.ptRegular11)
                                .foregroundStyle(.disabled)
                                .padding(.leading, 24)
                            Text("\(realmViewModel.settingData.models.learning)")
                                .font(.ptSemiBold14)
                                .foregroundStyle(.cwhite)
                            Text("주제")
                                .font(.ptRegular11)
                                .foregroundStyle(.disabled)
                                .padding(.leading, 24)
                            Text(topicData)
                                .font(.ptSemiBold14)
                                .foregroundStyle(.cwhite)
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 100, style: .continuous)
                                    .fill(.cwhite)
                                // TODO: 타이머 관련 회의
                                Text("00:00")
                                    .font(.ptRegular14)
                            }.frame(width: 84, height: 38)
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                        }
                    }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                }
            }.frame(maxWidth: .infinity, maxHeight: 138)
            HStack {
                Image(systemName: "info.circle")
                    .font(.ptRegular14)
                    .foregroundStyle(.constantsSemi)
                Text("통화가 끝나면 대화 내역과 피드백을 받아볼 수 있어요.")
                    .font(.ptRegular14)
                    .foregroundStyle(.constantsSemi)
            }
        }
            .padding(.vertical, 16)
    }
}

#Preview {
    CallingView(gotoRoot: .constant(true), topicTitle: "", model: RealmModel.init(), callId: nil)
        .environmentObject(RealmViewModel())
}
