//
//  MainView.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct MainView: View {

    @State var selectedTab: Tabs = .history

    var body: some View {
        switch selectedTab {
        case .home:
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
