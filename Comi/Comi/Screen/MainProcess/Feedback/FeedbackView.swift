//
//  FeedbackView.swift
//  Comi
//
//  Created by yimkeul on 5/5/24.
//

import SwiftUI

struct FeedbackView: View {

    @AppStorage("isOnboarding") var isOnboarding: Bool = true
    @Environment(\.dismiss) var dismiss
    @State private var isSelect: Bool = false
    @Binding var gotoRoot: Bool
    var model: RealmModel
    var topicData: String

    var body: some View {
        VStack {
            customNavBar()
            GeometryReader { geo in
                let size = geo.size
                // TODO: 채팅화면
                ScrollView {
                    Text("asdfa")
                        .font(.system(size: 50))
                    Spacer()
                        .frame(height: 116)
                }
                    .frame(maxWidth: .infinity, maxHeight: size.height)
                    .offset(y: 116)
                feedBackInterface()
                    .offset(y: 8)
            }
            bottomBtn()
        }
            .fullScreenCover(isPresented: $isOnboarding) {
            FeedbackManualTabView(isOnboarding: $isOnboarding)
        }
            .background(BackGround())
    }

    @ViewBuilder
    private func customNavBar() -> some View {
        HStack {
            Button {
                gotoRoot = false
            } label: {
                Image(systemName: "chevron.left")
                    .foregroundStyle(.disabled)
                    .font(.system(size: 24, weight: .semibold))
            }
            HStack(spacing: 4) {
                Text(model.name)
                    .font(.ptSemiBold18)
                Text(topicData)
                    .font(.ptRegular18)
            }.foregroundStyle(.black)
            Spacer()
        }
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func feedBackInterface() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
            VStack {
                Text("2024년 00월 00일 월요일")
                    .font(.ptRegular14)
                    .foregroundStyle(.cwhite)
                NavigationLink {
                    FeedbackContentView()
                        .navigationBarBackButtonHidden()
                } label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 326, height: 56)
                            .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.15, green: 0.83, blue: 0.67), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.46, green: 0.59, blue: 1), location: 1.00)
                                ],
                                startPoint: UnitPoint(x: 0, y: 1),
                                endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                            .cornerRadius(100)
                        Text("분석 내용 보기")
                            .font(.ptSemiBold16)
                            .foregroundStyle(.cwhite)
                    }.padding(.horizontal, 8)
                }

            }
        }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 24)
    }

    @ViewBuilder
    private func bottomBtn() -> some View {
        ZStack {
            HStack {
                newConversationBtn()
                Spacer()
                callBtn()
            }.padding(.horizontal, 24)
        }
            .frame(maxWidth: .infinity, minHeight: 82, maxHeight: 82, alignment: .center)
            .background {
            Rectangle()
                .fill(.cwhite)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .ignoresSafeArea()
        }
    }

    @ViewBuilder
    private func newConversationBtn() -> some View {
        ZStack {
            Rectangle()
                .fill(.cwhite)
                .padding(1)
                .overlay {
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .stroke(Color.blue2, lineWidth: 1)
            }
            Text("새로운 대화")
                .font(.ptSemiBold18)
                .foregroundStyle(.constantsSemi)
        }
            .frame(maxWidth: 163, maxHeight: 50)
    }

    @ViewBuilder
    private func callBtn() -> some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
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

            VStack {
                Text("전화하기")
                    .font(.ptSemiBold18)
                    .foregroundStyle(.cwhite)
            }
        }
            .frame(maxWidth: 163, maxHeight: 50)
    }
}

#Preview {
    FeedbackView(gotoRoot: .constant(true), model: RealmModel(id: 0, name: "카리나", englishName: "karina", state: .available, image: ""), topicData: "")
}
