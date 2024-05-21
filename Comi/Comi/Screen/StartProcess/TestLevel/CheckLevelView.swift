//
//  CheckLevelView.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI

struct CheckLevelView: View {

    @Environment(\.dismiss) var dismiss
    @State private var gotoTestView: Bool = false
    @Binding var userSetting: RealmSetting
    @Binding var isReady: Bool

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                VStack {
                    Text("테스트 안내")
                        .font(.ptSemiBold32)
                        .foregroundStyle(.black)
                        .padding(.top, 80)
                        .padding(.bottom, 12)

                    Text("아래 내용과 같이 진행합니다")
                        .font(.ptRegular14)
                        .foregroundStyle(.black)

                    ZStack {
                        RoundedRectangle(cornerRadius: 32, style: .continuous)
                            .fill(Color(red: 0.93, green: 0.93, blue: 0.93))
                        // TODO: 내용 추가 필요
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 80)
                        .padding(.bottom, 50)
                }.padding(.horizontal, 24)
                Spacer()
                BottomActionButton(action: { gotoTestView.toggle() }, title: "테스트 시작")
                    .background {
                        NavigationLink(destination: TestLevelView(userSetting: $userSetting, isReady: $isReady)
                        .navigationBarBackButtonHidden(),
                    isActive: $gotoTestView,
                    label: { EmptyView() }
                    ) }
            }
            customNavBar()
        }
            .background {
            BackGround()
        }
    }
    @ViewBuilder
    private func customNavBar() -> some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.disabled)
                        .font(.system(size: 24, weight: .semibold))
                }

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.clear)
                        .font(.system(size: 24, weight: .semibold))
                }.disabled(true)
            }
                .padding(.vertical, 16)
                .padding(.horizontal, 24)
            Spacer()
        }
    }
}

#Preview {
    CheckLevelView(userSetting: .constant(RealmSetting(userId: 0, level: 0, learning: "",local: "")), isReady: .constant(false))
}
