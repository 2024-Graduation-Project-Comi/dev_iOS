//
//  MainView.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab: Tab = .history
    var body: some View {
        VStack {
            Spacer()
            switch selectedTab {
            case .home:
                Text("home")
            case .history:
                HistoryView()
            case .contact:
                Text("contact")
            case .profile:
                Text("profile")
            }
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }.background {
            BackGround()
        }
    }
}

#Preview {
    MainView()
}
