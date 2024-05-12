//
//  HomeView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Tab

    var body: some View {
        VStack {
            Text("HomeView")
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }.background(BackGround())
    }
}

#Preview {
    HomeView(selectedTab: .constant(.home))
}
