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
    @State private var showMoreFunc: Bool = false
    @State private var showBG: Bool = false
    @Binding var selected: Int?
    var modelInfo: RealmModel
    var data: RealmCallRecord

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(showBG ? .newChatGray : .clear)
            VStack {
                Rectangle()
                    .fill(.clear)
                    .frame(height: 1)
                HStack {
                    VStack(alignment: .leading) {
                        Text(data.convCount <= 1 ? modelInfo.name : "\(modelInfo.name)(\(Int(data.convCount)))")
                            .font(.ptSemiBold18)
                        Text("\(data.topic) · \(data.times)")
                            .font(.ptRegular14)
                    }
                    Spacer()
                    Text(recentedDate)
                        .font(.ptRegular14)
                        .foregroundStyle(.constantsSemi)
                }
                    .contentShape(Rectangle())
                    .onTapGesture {
                    withAnimation {
                        toggleSelection(for: data.id)
                    }
                }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)

                if selected == data.id {
                    moreFunc()
                        .onAppear {
                        showBG = true
                        withAnimation(.easeInOut.delay(0.2)) {
                            showMoreFunc = true
                        }
                    }
                        .onDisappear {
                        showMoreFunc = false
                        showBG = false
                    }
                } else {
                    Divider()
                }
            }
        }
            .frame(maxWidth: .infinity, minHeight: 78)
            .onAppear {
            recentedDate = RealmViewModel.shared.formatDate(data: data.ended)
        }
    }

    private func toggleSelection(for id: Int) {
        selected = (selected == data.id) ? nil : data.id
    }

    @ViewBuilder
    private func moreFunc() -> some View {
        HStack {
            Button {
                gotoFeedbackView = true
            } label: {
                moreFuncButton(image: "Chat filled", title: "채팅보기")
            }
                .background(
                NavigationLink(
                    destination:
                        FeedbackView(
                            gotoRoot: $gotoFeedbackView,
                            targetCallID: String(selected ?? 0),
                            model: modelInfo,
                            topicData: data.topic)
                        .navigationBarBackButtonHidden(),
                    isActive: $gotoFeedbackView,
                    label: { EmptyView() }
                )
            )
            Button {
                gotoCallingView = true
                print("Test HistoryView : \(data.id)")
            } label: {
                moreFuncButton(image: "Call filled", title: "전화하기")
            }
                .background(
                    NavigationLink(destination: CallingView(gotoRoot: $gotoCallingView, topicTitle: self.data.topic, model: self.modelInfo, callId: selected)
                    .navigationBarBackButtonHidden(),
                isActive: $gotoCallingView,
                label: { EmptyView() }
                )
            )
        }
            .padding(.bottom, 16)
            .opacity(showMoreFunc ? 1 : 0)
    }

    @ViewBuilder
    private func moreFuncButton(image: String, title: String) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.cwhite)
                .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.blue2, lineWidth: 1)
            }

            HStack(spacing: 0) {
                Image(image)
                    .padding(.trailing, 20)
                Text(title)
                    .font(.ptRegular18)
                    .foregroundStyle(.blue2)
            }
        }
            .frame(width: 151, height: 48)
    }
}
