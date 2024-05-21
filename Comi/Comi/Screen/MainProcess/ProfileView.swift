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
        VStack(spacing: 0) {
            HStack {
                Text("프로필")
                    .font(.ptBold22)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)

            Spacer()
            Text("profile view")
            Text("userId : \(realmViewModel.userData.models.userId)")
            Text("email : \(realmViewModel.userData.models.email)")
            Text("remainTime : \(realmViewModel.userData.models.remainTime)")
            Text("isLogin : \(realmViewModel.userData.models.isLogin)")
            Text("isReady : \(realmViewModel.userData.models.isReady)")
            Text("Setting")
            Text("userId : \(realmViewModel.settingData.models.userId)")
            Text("level : \(realmViewModel.settingData.models.level)")
            Text("learning : \(realmViewModel.settingData.models.learning)")
            Text("local : \(realmViewModel.settingData.models.local)")
            Spacer()
            BottomTabBarView(selectedTab: $selectedTab)
        }.background(BackGround())
    }
}

#Preview {
    ProfileView(selectedTab: .constant(.profile))
}
