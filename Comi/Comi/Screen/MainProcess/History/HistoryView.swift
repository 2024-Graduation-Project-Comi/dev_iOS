//
//  HistoryView.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

struct HistoryView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @State private var selected: Int?
    @Binding var selectedTab: Tabs

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("최근 기록")
                    .font(.ptBold22)
                Spacer()
            }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            SearchBar()
                .padding(.bottom, 16)
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("오늘")
                        .font(.ptRegular14)
                    ForEach(
                        realmViewModel.callRecordData.models
                            .filter { Calendar.current.isDate($0.ended, inSameDayAs: Date()) }, id: \.self
                    ) { data in
                        let modelInfo =
                            realmViewModel.findModelInfo(modelId: data.modelId) ?? RealmModel(id: 999, name: "에러", englishName: "error", group: nil, state: .unavailable, image: "")
                        HistoryCard(selected: self.$selected, modelInfo: modelInfo, data: data)
                    }
                    Spacer().frame(height: 28)
                    Text("이전")
                        .font(.ptRegular14)

                    ForEach(
                        realmViewModel.callRecordData.models
                            .filter { !Calendar.current.isDate($0.ended, inSameDayAs: Date()) }, id: \.self
                    ) { data in
                        let modelInfo =
                            realmViewModel.findModelInfo(modelId: data.modelId) ?? RealmModel(id: 999, name: "에러", englishName: "error", group: nil, state: .unavailable, image: "")
                        HistoryCard(selected: self.$selected, modelInfo: modelInfo, data: data)
                    }
                }
                    .padding(.horizontal, 24)
                    .frame(alignment: .leading)
            }
                .padding(.bottom, 32)
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }
            .background {
            BackGround()
        }
    }
}

#Preview {
    HistoryView(selectedTab: .constant(.history))
        .background(BackGround())
}
