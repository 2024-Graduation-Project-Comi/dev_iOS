//
//  HistoryView.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

struct HistoryView: View {

    @State private var selected: Int?
    @Binding var selectedTab: Tabs
    @ObservedObject var callRecords = CallRecordsDB()

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text("최근 기록")
                        .font(.ptBold22)
                    Spacer()
                    Image("Search")
                }
                    .padding(.bottom, 24)
                    .padding(.horizontal, 24)
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {
                        Text("오늘")
                            .font(.ptRegular14)
                            .padding(.bottom, 8)
                        ForEach(callRecords.data.filter { Calendar.current.isDate($0.ended, inSameDayAs: Date()) }, id: \.callId) { data in
                            let modelInfo = callRecords.findModelInfo(modelId: data.modelId) ?? Models(id: 999, name: "에러", group: nil, state: .unavailable, image: "")
                            HistoryCard(selected: self.$selected, modelInfo: modelInfo, data: data)
                        }

                        Text("이전")
                            .font(.ptRegular14)
                            .padding(.bottom, 8)

                        ForEach(callRecords.data.filter { !Calendar.current.isDate($0.ended, inSameDayAs: Date()) }, id: \.callId) { data in
                            let modelInfo = callRecords.findModelInfo(modelId: data.modelId) ?? Models(id: 999, name: "에러", group: nil, state: .unavailable, image: "")
                            HistoryCard(selected: self.$selected, modelInfo: modelInfo, data: data)
                        }
                    }
                        .padding(.horizontal, 24)
                        .frame(alignment: .leading)
                }
                .padding(.bottom, 32)
                BottomTabBarView(selectedTab: $selectedTab)
            }
                .background(BackGround())
        }
        .onAppear {
            Task {
                await callRecords.getData()
            }
        }
    }
}

#Preview {
    HistoryView(selectedTab: .constant(.history))
        .background(BackGround())
}
