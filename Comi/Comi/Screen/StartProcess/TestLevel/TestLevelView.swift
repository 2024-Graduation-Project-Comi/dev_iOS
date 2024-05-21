//
//  TestLevelView.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI

struct TestLevelView: View {

    @State private var gotoLevelResult: Bool = false
    @Binding var userSetting: RealmSetting
    @Binding var isReady: Bool

    var body: some View {
        VStack(spacing: 0) {
            callInterface()
            Spacer()
        }.background(BackGround())
    }
    @ViewBuilder
    private func callInterface() -> some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.cwhite)
                    .shadow(radius: 100, y: -100)

                VStack {
                    HStack(alignment: .center, spacing: 16) {
                        // TODO: 이미지 변경
//                        KFImage(URL(string: model.image))
//                            .fade(duration: 0.25)
//                            .startLoadingBeforeViewAppear(true)
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 62, height: 62)
//                            .clipShape(Circle())
                        Circle()
                            .frame(width: 62, height: 62)

                        Text("COMI")
                            .font(.ptSemiBold18)
                        Spacer()
                        Button {
                            gotoLevelResult = true
                        } label: {
                            Image("Disconnected")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }
                            .background {
                                NavigationLink(destination: LevelResultView(userSetting: $userSetting, isReady: $isReady)
                                .navigationBarBackButtonHidden(),
                            isActive: $gotoLevelResult,
                            label: { EmptyView() })
                        }

                    }
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                    ZStack {
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                        // TODO: 언어 설정 나중에 받아와야함
                        HStack(alignment: .center, spacing: 8) {
                            Text("언어")
                                .font(.ptRegular11)
                                .foregroundStyle(.disabled)
                                .padding(.leading, 24)
                            Text("\(userSetting.learning)")
                                .font(.ptSemiBold14)
                                .foregroundStyle(.cwhite)
                            Text("주제")
                                .font(.ptRegular11)
                                .foregroundStyle(.disabled)
                                .padding(.leading, 24)
                            Text("레벨 테스트")
                                .font(.ptSemiBold14)
                                .foregroundStyle(.cwhite)
                            Spacer()
                            ZStack {
                                RoundedRectangle(cornerRadius: 100, style: .continuous)
                                    .fill(.cwhite)
                                // TODO: 타이머 관련 회의
                                Text("00:00")
                                    .font(.ptRegular14)
                            }.frame(width: 84, height: 38)
                                .padding(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 4))
                        }
                    }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                }
            }.frame(maxWidth: .infinity, maxHeight: 138)
            HStack {
                Image(systemName: "info.circle")
                    .font(.ptRegular14)
                    .foregroundStyle(.constantsSemi)
                Text("질문에 대답을 해주세요")
                    .font(.ptRegular14)
                    .foregroundStyle(.constantsSemi)
            }
        }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
    }

}

#Preview {
    TestLevelView(userSetting: .constant(RealmSetting(userId: 0, level: 0, learning: "",local: "")), isReady: .constant(false))
}
