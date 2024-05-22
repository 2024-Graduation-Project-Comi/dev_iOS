//
//  ConversationView.swift
//  Comi
//
//  Created by 문영균 on 5/18/24.
//

import SwiftUI

struct ConversationView: View {

    @StateObject private var conversationViewModel = ConversationViewModel()
//    @State var requestData: ChatRequestData?
    @State var response: ChatResponseData?
    @State var id: String = ""
    @State var topic: String = ""
    @State var conversationLanguage: String = ""
    @State var explanationLanguage: String = ""
    @State var model: String = ""

    var body: some View {
        HStack(content: {
            if let response {
                Text("Conversation: \(response.conv)")
                Text("Explanation: \(response.explain)")
                Text("Fix: \(response.fix ?? "NaN")")
                Text("Evaluation: \(response.eval.description)")
            } else {
                Text("대답을 기다리는 중이에요...")
            }

        })
        VStack {
            TextField("id 입력", text: $id)
            TextField("토픽 입력", text: $topic)
            TextField("대화 언어 입력", text: $conversationLanguage)
            TextField("설명 언어 입력", text: $explanationLanguage)
            TextField("모델 입력", text: $model)

            Button(action: {
                let requestData = ChatRequestData(id: id, topic: topic, conversationLanguage: conversationLanguage, explanationLanguage: explanationLanguage, model: model)

                conversationViewModel.startConversation(chatRequestData: requestData) { result in
                    switch result {
                    case .success(let responseData):
                        print("Conversation: \(responseData.conv)")
                        print("Explanation: \(responseData.explain)")
                        print("Evaluation: \(responseData.eval)")
                        print("Fix: \(responseData.fix ?? "")")
                        response = responseData
                    case .failure(let error):
                        print("Error occurred: \(error)")
                    }
                }
            }, label: {
                Text("대화를 시작해봅시다.")
            })

            Button {
                let requestData = ChatRequestData(id: "999", topic: "movie", conversationLanguage: "en", explanationLanguage: "ko", model: "winter")

                conversationViewModel.startConversation(chatRequestData: requestData) { result in
                    switch result {
                    case .success(let responseData):
                        print("Conversation: \(responseData.conv)")
                        print("Explanation: \(responseData.explain)")
                        print("Evaluation: \(responseData.eval)")
                        print("Fix: \(responseData.fix)")
                        response = responseData
                    case .failure(let error):
                        print("Error occurred: \(error)")
                    }
                }
            } label: {
                Text("Sample로 한번에!")
            }

        }
        Divider()
    }
}

#Preview {
    ConversationView()
}
