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
        VStack {
            Spacer()
            Text("HomeView")
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
