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
    @State var showAnimation: Bool = false
    @State var progress: Double = 0.0
    @Binding var userSetting: RealmSetting
    @Binding var isReady: Bool
    @StateObject var userSettingViewModel = UserSettingViewModel()

    var body: some View {
        VStack(spacing: 0) {
            GeometryReader { geo in
                let size = geo.size
                ZStack {
                    Circle()
                        .trim(from: 0.0, to: 0.5)
                        .stroke(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 24, lineCap: .round))
                        .rotationEffect(.degrees(180))
                        .frame(width: size.width, height: size.width)
                    Circle()
                        .trim(from: 0.0, to: showAnimation ? min(progress, 1.0) * 0.5 : 0.0)
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 24, lineCap: .round))
                        .rotationEffect(.degrees(180))
                        .frame(width: size.width, height: size.width)
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 30, height: 30)
                        Circle()
                            .stroke(Color.black, lineWidth: 5)
                            .frame(width: 30, height: 30)
                    }
                        .offset(x: size.width / 2 * cos(CGFloat(min(progress, 1.0) * .pi)),
                                y: size.width / 2 * sin(CGFloat(min(progress, 1.0) * .pi)))
                        .rotationEffect(.degrees(180))
                    VStack {
                        Text("코미가 생각한 당신의 회화 수준은?")
                            .font(.ptSemiBold18)
                            .foregroundStyle(.constantsSemi)

                        if showAnimation {
                            Text("LEVEL : \(level)")
                                .font(.ptSemiBold58)
                                .foregroundStyle(.black)
                        }
                    }
                }
                    .frame(width: size.width, height: size.height)
            }.padding()
            Spacer()
            BottomActionButton(action: { userSettingViewModel.postInit(data: userSetting) { result in
                    if result == true {
                        Task {
                            await realmViewModel.settingData.updateData(data: userSetting)
                            await realmViewModel.userData.updateData(id: userSetting.userId)
                            await UsersDB.shared.updateData(data: realmViewModel.userData.models)
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                withAnimation {
                    showAnimation = true
                    switch level {
                    case 1:
                        progress = 0.2
                    case 2:
                        progress = 0.4
                    case 3:
                        progress = 0.6
                    case 4:
                        progress = 0.8
                    case 5:
                        progress = 1.0
                    default:
                        progress = 0.0
                    }
                }
            })
        }
            .background(BackGround())
    }
}
