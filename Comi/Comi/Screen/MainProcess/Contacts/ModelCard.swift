//
//  ModelCard.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI
import Kingfisher

struct ModelCard: View {

    @State private var showAlert: Bool = false
    @Binding var selectedModel: RealmModel
    @Binding var gotoModelDetailView: Bool
    var data: RealmModel

    var body: some View {
        HStack(spacing: 0) {
            HStack {
                ZStack {
                    KFImage(URL(string: data.image))
                        .fade(duration: 0.25)
                        .startLoadingBeforeViewAppear(true)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 62, height: 62)
                        .clipShape(Circle())

                    if data.state == .locked {
                        Image("Lock")
                            .offset(x: 20, y: 20)
                    } else {
                        Circle()
                            .fill(data.state == .available ? .availableCircle : .unavailableCircle)
                            .frame(width: 16, height: 16)
                            .offset(x: 20, y: 20)
                            .overlay {
                            Circle()
                                .stroke(Color.cwhite, lineWidth: 1)
                                .offset(x: 20, y: 20)
                        }
                    }
                }
                Text(data.name)
                    .font(.ptSemiBold18)
                    .foregroundStyle(.black)
                Spacer()
            }
            .alert(isPresented: $showAlert) {
                switch data.state {
                case .locked:
                    return Alert(title: Text("알림"), message: Text("추가 결제 후 사용 가능한 모델입니다"))
                case .unavailable:
                    return Alert(title: Text("알림"), message: Text("업데이트 예정 모델입니다"))
                default :
                    return Alert(title: Text(""))
                }
            }
                .contentShape(Rectangle())
                .onTapGesture {
                if data.state == .available {
                    selectedModel = data
                    gotoModelDetailView = true
                } else {
                    showAlert = true
                }
            }
            // TODO: 음성 미리듣기는 나중에
//            playButton()
        }.padding(.bottom, 4)
    }

    @ViewBuilder
    private func playButton() -> some View {
        ZStack(alignment: .center) {
            Image("PlayButton")
                .resizable()
                .frame(width: 30, height: 30)
        }
            .frame(width: 62, height: 62)
            .background(.pink)
            .onTapGesture {
            print("play sound")
        }
    }
}
