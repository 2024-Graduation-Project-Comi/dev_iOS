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
            VStack(alignment: .leading) {
                Text("학습 기록")
                    .font(.ptBold22)
                    .foregroundStyle(.black)
                Text("코미와 학습한 기록입니다")
                    .font(.ptRegular11)
                    .foregroundStyle(.constantsSemi)
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
                        realmViewModel.callRecordData.models.reversed()
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
                        realmViewModel.callRecordData.models.reversed()
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
                .refreshable(action: {
                let userID = realmViewModel.userData.models.userId
                realmViewModel.callRecordData.updateData(id: userID)
            })
                .onAppear {
                    print("HistoryView id : \(realmViewModel.userData.models.userId)")
                }
                .padding(.bottom, 32)
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
