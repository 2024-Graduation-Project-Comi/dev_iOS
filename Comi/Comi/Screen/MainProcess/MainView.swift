//
//  MainView.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct MainView: View {
    @State var selectedTab: Tab = .contact
    var body: some View {
        ZStack {
            switch selectedTab {
            case .home:
                // MARK: 나중에 작업해야함
                HomeView()
            case .history:
                HistoryView()
            case .contact:
                ContectView()
            case .profile:
                ProfileView()
            }
            VStack {
                Spacer()
                BottomTabBarView(selectedTab: $selectedTab)
            }
        }
    }
}

#Preview {
    MainView()
}
