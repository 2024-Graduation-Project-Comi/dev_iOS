//
//  LoginView.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct LoginView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @Binding var isLogin: Bool
    @Binding var isReady: Bool

    var body: some View {
        if isLogin == false {
            loginView()
        } else {
            NavigationView {
                CheckLangView(isReady: $isReady)
                    .environmentObject(realmViewModel)
                    .navigationBarHidden(true)
            }
        }
    }

    @ViewBuilder
    private func loginView() -> some View {
        VStack {
            Text("COMI")
                .font(.ptSemiBold32)
                .foregroundStyle(.black)
                .padding(.top, 80)
                .padding(.bottom, 12)

            Text("이상형의 목소리와 함께 배우는 AI 외국어 학습")
                .font(.ptRegular14)
                .foregroundStyle(.black)
            Spacer()

            BottomActionButton(action: {
                Task {
//                    let userID = realmViewModel.userData.makeID()
                    let userID = 1
                    // TODO: userID로 변경하기
                    await realmViewModel.userData.updateData(id: userID)
                    await UsersDB.shared.insertData(id: userID)
                    isLogin = realmViewModel.userData.models.isLogin
                    realmViewModel.callRecordData.updateData(id: userID)
                }
            }, title: "간편 로그인")
        }
            .background(BackGround())
    }
}

@ViewBuilder
private func loginBtn() -> some View {
    ZStack {
        Rectangle()
            .foregroundColor(.clear)
            .frame(width: 342, height: 62)
            .background(
            LinearGradient(
                stops: [
                    Gradient.Stop(color: .blue2, location: 0.00),
                    Gradient.Stop(color: .blue1, location: 1.00)
                ],
                startPoint: UnitPoint(x: 0, y: 1),
                endPoint: UnitPoint(x: 1, y: 0)
            )
        )
            .cornerRadius(100)
        Text("간편 로그인")
            .font(.ptSemiBold18)
            .foregroundStyle(.cwhite)
    }
}

#Preview {
    LoginView(isLogin: .constant(false), isReady: .constant(false))
}
