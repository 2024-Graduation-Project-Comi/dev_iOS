//
//  HomeView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct HomeView: View {

    @Binding var selectedTab: Tabs
    var lan: String = Locale.current.languageCode ?? "Unknow"
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text("홈")
                    .font(.ptBold22)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            Spacer()
            Text(lan)
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }.background(BackGround())
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
}
