//
//  CheckLevelView.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI
import Alamofire

struct CheckLevelView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @State var userSetting: RealmSetting = .init(userId: 0, local: "")
    @Binding var isReady: Bool
    @StateObject var userSettingViewModel = UserSettingViewModel()
    @State var test: Bool = false
    var body: some View {

        VStack {
            Spacer()
            Button {
                userSettingViewModel.postInit(data: userSetting) { result in
                    test = result
                    isReady = test
                }
            } label: {
                Text("클릭")
            }
            Text(test ? "tt " : "xx")
            Spacer()
        }
            .onAppear {
            print("userID : \(realmViewModel.userData.models.userId)")
            userSetting.userId = realmViewModel.userData.models.userId
            userSetting.local = Locale.current.languageCode ?? ""
            userSetting.learning = "en"
            userSetting.level = 1
        }
    }
}

#Preview {
    CheckLevelView(isReady: .constant(false))
}
