//
//  LevelResultView.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI

struct LevelResultView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    // TODO: level 수정 필요
    @State var level: Int = 0
    @Binding var userSetting: RealmSetting
    @Binding var isReady: Bool
    @StateObject var userSettingViewModel = UserSettingViewModel()

    var body: some View {
        VStack(spacing: 0) {
            VStack {
                Text("테스트 결과")
                    .font(.ptSemiBold32)
                    .foregroundStyle(.black)
                    .padding(.top, 80)
                    .padding(.bottom, 12)

                Text("테스트 결과")
                    .font(.ptRegular14)
                    .foregroundStyle(.black)

                ZStack {
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .fill(Color(red: 0.93, green: 0.93, blue: 0.93))
                    // TODO: 내용 추가 필요
                    Text("레벨 : \(level)")
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.top, 80)
                    .padding(.bottom, 50)
            }.padding(.horizontal, 24)
            Spacer()
            BottomActionButton(action: { userSettingViewModel.postInit(data: userSetting) { result in
                if result == true {
                    Task {
                        await realmViewModel.settingData.updateData(data: userSetting)
                        await realmViewModel.userData.updateData(id: userSetting.userId)
                        isReady = realmViewModel.userData.models.isReady
                    }
                } else {
                    print("error in LevelResultView")
                }
                    print("클릭 : \(result)")
                }
            }, title: "COMI 시작하기")
        }
        .onAppear {
            // MARK: level 평가 api? 받는곳
            level = 1
            userSetting.level = level
        }
    }
}
