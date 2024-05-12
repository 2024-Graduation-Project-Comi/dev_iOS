//
//  CallingView.swift
//  Comi
//
//  Created by yimkeul on 5/4/24.
//

import SwiftUI

enum CallState {
    case ready
    case ai
    case wait
    case user
}

struct CallingView: View {

    @State private var background: callState = .ready
    var modelData: sModels
    @Binding var topicData: TopicData?
    @Binding var gotoRoot: Bool
    @State private var gotoFeedback: Bool = false
    var body: some View {
        VStack {
            callInterface(modelData: modelData, topicData: topicData)
            Spacer()
            // TODO: 영균 기능 합치고 텍스트
        }
            .padding(.horizontal, 24)
            .background(CallBackground(status: $background))
    }
    @ViewBuilder
    private func callInterface(modelData: sModels, topicData: TopicData?) -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.cwhite)
                    .shadow(radius: 100, y: -100)

                VStack {
                    HStack(alignment: .center, spacing: 16) {
                        Image("kari")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 62, height: 62)
                            .clipShape(Circle())

                        Text(modelData.name)
                            .font(.ptSemiBold18)
                        Spacer()
                        Button {
                            gotoFeedback = true
                        } label: {
                            Image("Disconnected")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }.background(
                            NavigationLink(
                            destination: FeedbackView(model: modelData, topicData: topicData,gotoRoot: $gotoRoot)
                                .navigationBarHidden(true),
                            isActive: $gotoFeedback,
                            label: {EmptyView()}
                            )
                        )
                        
                    }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    ZStack {
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                        // TODO: 언어 설정 나중에 받아와야함
                        HStack(alignment: .center, spacing: 8) {
                            Text("언어")
                                .font(.ptRegular11)
                                .foregroundStyle(.disabled)
                                .padding(.leading, 24)
                            Text("TODO")
                                .font(.ptSemiBold14)
                                .foregroundStyle(.cwhite)
                            Text("주제")
                                .font(.ptRegular11)
                                .foregroundStyle(.disabled)
                                .padding(.leading, 24)
                            Text(topicData?.topic.rawValue ?? "--")
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
                                .padding(4)
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
    }
}



#Preview {
    CallingView(modelData: sModels(id: 0, name: "카리나", state: .available, image: ""), topicData: .constant(.init(idx: 0, topic: .비지니스, desc: "")), gotoRoot: .constant(true))
}
