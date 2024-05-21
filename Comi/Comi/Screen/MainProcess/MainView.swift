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
        NavigationView {
            switch selectedTab {
            case .home:
                HomeView(selectedTab: $selectedTab)
                    .navigationBarHidden(true)
            case .history:
                HistoryView(selectedTab: $selectedTab)
                    .navigationBarHidden(true)
            case .contact:
                ContactsView(selectedTab: $selectedTab)
                    .navigationBarHidden(true)
            case .profile:
                ProfileView(selectedTab: $selectedTab)
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    MainView()
}
