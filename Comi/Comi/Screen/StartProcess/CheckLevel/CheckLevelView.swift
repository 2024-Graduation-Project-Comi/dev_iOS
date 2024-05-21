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
    @State private var selected: LanguageData?
    @State private var isSelect: Bool = false
    @Binding var isReady: Bool
    @StateObject var userSettingViewModel = UserSettingViewModel()

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Text("언어 선택")
                    .font(.ptSemiBold32)
                    .foregroundStyle(.black)
                    .padding(.top, 80)
                    .padding(.bottom, 12)

                Text("학습할 언어를 선택하세요")
                    .font(.ptRegular14)
                    .foregroundStyle(.black)
                ScrollView(showsIndicators: false) {
                    ForEach(languageDatas, id: \.self) { data in
                        LanguageCard(selected: self.$selected, isSelect: $isSelect, languageData: data)
                    }
                }.padding(.top, 80)
            }.padding(.horizontal, 24)
            Spacer()
            BottomActionButton(action: { userSettingViewModel.postInit(data: userSetting) { result in
                    isReady = result
                    print("클릭 : \(isReady)")
                }
            }, title: "테스트 시작")
            .opacity(isSelect ? 1 : 0)
            .offset(y: isSelect ? 0 : 100)
        }

            .background(BackGround())

            .onAppear {
            userSetting.userId = realmViewModel.userData.models.userId
            userSetting.local = Locale.current.languageCode ?? ""
//            userSetting.learning = "en"
//            userSetting.level = 1
        }
    }
}

#Preview {
    CheckLevelView(isReady: .constant(false))
        .environmentObject(RealmViewModel())
}
