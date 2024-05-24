//
//  FeedbackContentView.swift
//  Comi
//
//  Created by yimkeul on 5/5/24.
//

import SwiftUI

struct FeedbackContentView: View {

    @Environment(\.dismiss) var dismiss
    @State private var checkType: Bool = false
    // 원형 그래프 변수
    @State private var value: CGFloat = 0.01
    @State private var showValue: Bool = false
    @State private var scoreColor: Color = .clear

    var body: some View {
        VStack {
            customNavBar()
            feedBackInterface()
            Group {
                Text(checkType ? "어휘 점수" : "발음 점수")
                    .font(.ptSemiBold18)
                ScorePieChart(value: $value, showValue: $showValue, scoreColor: $scoreColor)
                    .padding(.top, 24)
            }.padding(.top, 12)
            Spacer()
        }
        .background(BackGround())
    }

    @ViewBuilder
    private func customNavBar() -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image("Close")
                    .foregroundStyle(.black)
            }
            Spacer()
            Text("대화 내용 분석")
                .font(.ptSemiBold18)
                .foregroundStyle(.black)
            Spacer()
            Image("Close")
                .foregroundStyle(.clear)
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
                    .padding(.top, 16)

                GeometryReader { geo in
                    let size = geo.size
                    ZStack {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.cwhite)
                            .frame(width: size.width, height: 56)
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .foregroundColor(.clear)
                            .frame(width: size.width / 2, height: 48)
                            .background(
                            LinearGradient(
                                stops: [
                                    Gradient.Stop(color: Color(red: 0.28, green: 0.43, blue: 0.88), location: 0.00),
                                    Gradient.Stop(color: Color(red: 0.46, green: 0.59, blue: 1), location: 1.00)
                                ],
                                startPoint: UnitPoint(x: 0, y: 1),
                                endPoint: UnitPoint(x: 1, y: 0)
                            )
                        )
                            .cornerRadius(30)
                            .offset(x: checkType ? size.width / 4 - 4 : -size.width / 4 + 4)

                        HStack {
                            Spacer()
                                .frame(width: 68)
                            Button {
                                withAnimation {
                                    checkType = false
                                }
                            } label: {
                                Text("발음")
                                    .font(.ptSemiBold18)
                                    .foregroundStyle(checkType ? .constantsSemi : .cwhite)
                            }
                            Spacer()
                            Button {
                                withAnimation {
                                    checkType = true
                                }
                            } label: {
                                Text("어휘")
                                    .font(.ptSemiBold18)
                                    .foregroundStyle(checkType ? .cwhite : .constantsSemi)

                            }
                            Spacer()
                                .frame(width: 68)
                        }
                    }
                        .frame(width: size.width, height: size.height)
                }
                    .padding(.horizontal, 4)
            }
        }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 24)
    }
}

#Preview {
    FeedbackContentView()
}
