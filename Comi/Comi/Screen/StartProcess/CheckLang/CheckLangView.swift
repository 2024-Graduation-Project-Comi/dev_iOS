//
//  CheckLangView.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI
import Alamofire

struct CheckLangView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @State var userSetting: RealmSetting = .init(userId: 0, level: 0, learning: "",local: "")
    @State private var selected: LanguageData?
    @State private var isSelect: Bool = false
    @State private var gotoLevelView: Bool = false
    @Binding var isReady: Bool

    var body: some View {
        VStack(spacing: 0) {
            VStack {
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
                        LanguageCard(selected: self.$selected, isSelect: $isSelect, userSetting: $userSetting, languageData: data)
                    }
                }
                    .padding(.top, 80)
            }.padding(.horizontal, 24)
            Spacer()
            BottomActionButton(action: { gotoLevelView.toggle() }, title: "테스트 시작")
                .opacity(isSelect ? 1 : 0)
                .offset(y: isSelect ? 0 : 100)
                .background {
                    NavigationLink(destination: CheckLevelView(userSetting: $userSetting, isReady: $isReady)
                    .navigationBarBackButtonHidden(),
                isActive: $gotoLevelView,
                label: { EmptyView() })
            }

        }
            .background(BackGround())
            .onAppear {
            userSetting.userId = realmViewModel.userData.models.userId
            userSetting.local = Locale.current.languageCode ?? ""
        }
    }
}

#Preview {
    CheckLangView(isReady: .constant(false))
        .environmentObject(RealmViewModel())
}
