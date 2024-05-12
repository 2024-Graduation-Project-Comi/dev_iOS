//
//  ProfileView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct ProfileView: View {
    @Binding var selectedTab: Tabs
    var body: some View {
        VStack {
            Text("profile view")
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }.background(BackGround())
    }
}

#Preview {
    ProfileView(selectedTab: .constant(.profile))
}
