//
//  FeedbackView.swift
//  Comi
//
//  Created by yimkeul on 5/5/24.
//

import SwiftUI

struct FeedbackView: View {
    @Environment(\.dismiss) var dismiss

    var model: sModels
    var topicData: TopicData?
    @Binding var gotoRoot: Bool

    @State private var isSelect: Bool = false
    

    var body: some View {
        VStack {
            backButton()
            GeometryReader { geo in
                let size = geo.size
                // TODO: 채팅화면
                ScrollView {
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Text("asdfa")
                        .font(.system(size: 50))
                    Spacer()
                        .frame(height: 116)
                }
                .frame(maxWidth: .infinity, maxHeight: size.height)
                .offset(y : 116)
                feedBackInterface()
                    .offset(y: 8)
            }
            Spacer()
            bottomBtn()
        }
            .background(BackGround())


    }

    @ViewBuilder
    private func backButton() -> some View {
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
                Text(topicData?.topic.rawValue ?? "자유주제")
                    .font(.ptRegular18)
            }.foregroundStyle(.black)
            Spacer()
        }.padding(.horizontal, 24)
    }
    @ViewBuilder
    private func feedBackInterface() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
            VStack {
                Text("날짜 조정해야함")
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
                                Gradient.Stop(color: Color(red: 0.46, green: 0.59, blue: 1), location: 1.00),
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
            if isSelect { } else {
                HStack {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(
                                .newChatGray
                        )
                            .cornerRadius(100)

                        VStack {
                            Text("새로운 대화")
                                .font(.ptSemiBold18)
                                .foregroundStyle(.constantsSemi)
                        }
                    }
                        .frame(maxWidth: 163, maxHeight: 50)
                    Spacer()
                    ZStack {
                        Rectangle()
                            .foregroundColor(.clear)
                            .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: .blue2, location: 0.00),
                                    Gradient.Stop(color: .blue1, location: 1.00),
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
                }.padding(.horizontal, 24)
            }
        }.frame(maxWidth: .infinity, minHeight: 116, maxHeight: 116, alignment: .center)
            .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.cwhite)
                .ignoresSafeArea()
        }
    }
}


#Preview {
    FeedbackView(model: sModels(id: 0, name: "카리나", state: .available, image: ""), gotoRoot: .constant(true))
}
