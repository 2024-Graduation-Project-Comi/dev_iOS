//
//  CheckLevelView.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI
import Speech

struct CheckLevelView: View {

    @Environment(\.dismiss) var dismiss
    @State private var gotoTestView: Bool = false
    @Binding var userSetting: RealmSetting
    @Binding var isReady: Bool
    @State var recordingPermission: Bool = false
    @State var speechPermission: Bool = false
    @State private var alert: Bool = false

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
                    }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 80)
                        .padding(.bottom, 50)
                }.padding(.horizontal, 24)
                Spacer()
                BottomActionButton(action: {
                    let dispachGroup = DispatchGroup()

                    dispachGroup.enter()
                    AVAudioSession.sharedInstance().requestRecordPermission { granted in
                        if granted {
                            recordingPermission = true
                            dispachGroup.leave()
                        } else {
                        }
                    }
                    dispachGroup.enter()
                    SFSpeechRecognizer.requestAuthorization { status in
                        switch status {
                        case .notDetermined, .denied, .restricted:
                            print("\(status.rawValue)")
                        case .authorized:
                            print("\(status.rawValue)")
                            speechPermission = true
                        @unknown default:
                            print("Unknown case")
                        }
                        dispachGroup.leave()
                    }
                    dispachGroup.notify(queue: .main) {
                        if recordingPermission && speechPermission {
                            gotoTestView.toggle()
                        } else {
                            alert = true
                        }
                    }

                }, title: "테스트 시작")
                .alert(isPresented: $alert) {
                    Alert(title: Text("녹음 및 음성 인식 권한이 필요합니다"), message: Text("설정에서 권한을 허용해주세요"), dismissButton: .default(Text("확인")))
                }
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
