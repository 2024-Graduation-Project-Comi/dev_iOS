//
//  ProfileView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct ProfileView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @Binding var selectedTab: Tabs

    var body: some View {
        VStack {
            Spacer()
            Text("profile view")
            Text("userId : \(realmViewModel.userData.models.userId)")
            Text("email : \(realmViewModel.userData.models.email)")
            Text("remainTime : \(realmViewModel.userData.models.remainTime)")
            Text("isLogin : \(realmViewModel.userData.models.isLogin)")
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }.background(BackGround())
    }
}

#Preview {
    ProfileView(selectedTab: .constant(.profile))
}
