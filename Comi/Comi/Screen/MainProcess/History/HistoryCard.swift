//
//  HistoryCard.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

struct HistoryCard: View {

    @State private var recentedDate = ""
    @State private var animated: Bool = false
    @State private var isMore: Bool = false
    @State private var gotoCallingView: Bool = false
    @State private var gotoFeedbackView: Bool = false
    @Binding var selected: Int?
    var modelInfo: RealmModel
    var data: RealmCallRecord

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.cardBG)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(data.convCount == 0 ? modelInfo.name : "\(modelInfo.name)(\(Int(data.convCount)))")
                            .font(.ptSemiBold18)
                        Text("\(data.topic) · \(data.times)")
                            .font(.ptRegular14)
                    }
                    Spacer()
                    Text(recentedDate)
                        .font(.ptRegular14)
                        .foregroundStyle(.constantsSemi)
                }
                if selected == data.id {
                    moreFunc()
                }
            }.padding(16)
        }
        .frame(maxWidth: .infinity, minHeight: 78)
        .padding(.bottom, 8)
        .onTapGesture {
            withAnimation {
                selected = selected == data.id ? nil : data.id
            }
        }
        .onAppear {
            recentedDate = CallRecordsDB.shared.formatDate(data: data.ended)
        }
    }

    @ViewBuilder
    private func moreFunc() -> some View {
        HStack {
            Button {
                gotoFeedbackView = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.blue2)

                    HStack(spacing: 0) {
                        Image("Chat")
                            .padding(.trailing, 20)
                        Text("채팅보기")
                            .font(.ptRegular18)
                            .foregroundStyle(.cwhite)
                    }
                }
                    .frame(width: 151, height: 48)
            }
                .background(
                NavigationLink(
                    destination:
                        FeedbackView(gotoRoot: $gotoFeedbackView, model: modelInfo, topicData: data.topic)
                        .navigationBarBackButtonHidden(),
                    isActive: $gotoFeedbackView,
                    label: { EmptyView() }
                )
            )
            Button {
                gotoCallingView = true
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                        .fill(.blue2)
                        .opacity(0.87)

                    HStack(spacing: 0) {
                        Image("Call")
                            .padding(.trailing, 20)
                        Text("전화하기")
                            .font(.ptRegular18)
                            .foregroundStyle(.cwhite)
                    }
                }.frame(width: 151, height: 48)
            }
                .background(
                    NavigationLink(destination: CallingView(gotoRoot: $gotoCallingView, topicTitle: self.data.topic, model: self.modelInfo)
                    .navigationBarBackButtonHidden(),
                isActive: $gotoCallingView,
                label: { EmptyView() }
                )
            )
        }
    }
}
