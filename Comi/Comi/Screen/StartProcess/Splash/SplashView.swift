//
//  SplashView.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI
import AVFoundation
struct SplashView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel

    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            VStack {
                Spacer()
                ZStack {
                    Circle()
                        .foregroundStyle(.red2)
                        .frame(width: 480, height: 480)
                        .offset(x: (-480 / 2))
                    Circle()
                        .foregroundStyle(.blue0)
                        .frame(width: 480, height: 480)
                        .offset(x: (480 / 2) - 100)
                }.blur(radius: 20)
                Spacer()
            }
                .background(.cwhite)

            VStack {
                Text("Comi")
                    .font(.ptSemiBold32)
                Text("이상형의 목소리와 함께 배우는 외국어 학습")
                    .font(.ptRegular14)
            }.frame(width: size.width, height: size.height)
        }
            .onAppear {
            Task {
                await realmViewModel.start()
                configureAudioSession()
            }
        }
    }
}

#Preview {
    SplashView()
        .environmentObject(RealmViewModel())
}

extension SplashView {
    func configureAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        Task {
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default, options: [])
                try audioSession.setActive(true)
                try audioSession.overrideOutputAudioPort(.speaker)
            } catch {
                print("Failed to configure audio session: \(error.localizedDescription)")
            }

        }
    }
}
