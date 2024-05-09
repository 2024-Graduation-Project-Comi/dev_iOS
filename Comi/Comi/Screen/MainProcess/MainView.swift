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
        switch selectedTab {
        case .home:
            // MARK: 나중에 작업해야함
            HomeView(selectedTab: $selectedTab)
        case .history:
            HistoryView(selectedTab: $selectedTab)
        case .contact:
            ContactsView(selectedTab: $selectedTab)
        case .profile:
            ProfileView(selectedTab: $selectedTab)
        }
    }
}

#Preview {
    MainView()
}
