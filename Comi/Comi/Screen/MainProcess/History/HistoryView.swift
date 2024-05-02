//
//  HistoryView.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

struct HistoryView: View {
    @State private var selected: Int?
    @Binding var selectedTab: Tab
    var body: some View {
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
                    ForEach(sampleHistoryData.filter { Calendar.current.isDate($0.ended, inSameDayAs: Date()) }, id: \.call_id) { data in
                        HistoryCard(data: data, selected: self.$selected)
                    }

                    Text("이전")
                        .font(.ptRegular14)
                        .padding(.bottom, 8)
                    ForEach(sampleHistoryData.filter { !Calendar.current.isDate($0.ended, inSameDayAs: Date()) }, id: \.call_id) { data in
                        HistoryCard(data: data, selected: self.$selected)
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
}

#Preview {
    HistoryView(selectedTab: .constant(.history))
        .background(BackGround())
}
