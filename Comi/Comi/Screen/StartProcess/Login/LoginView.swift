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

    var body: some View {
        ZStack {
            BackGround()
            VStack {
                Spacer()
                Button {
                    Task {
                        await realmViewModel.userData.updateData(id: 1)
                        isLogin = realmViewModel.userData.models.isLogin
                    }
                } label: {
                    loginBtn()
                }

                HStack {
                    Text("회원이 아니신가요?")
                        .font(.ptRegular14)
                        .foregroundStyle(.gray)
                    Button { } label: {
                        Text("회원가입")
                            .font(.ptRegular14)
                    }
                }
                    .padding(.top, 63)
                    .padding(.bottom, 16)
            }
        }
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
        Text("로그인")
            .font(.ptSemiBold18)
            .foregroundStyle(.cwhite)
    }
}

#Preview {
    LoginView(isLogin: .constant(false))
}
