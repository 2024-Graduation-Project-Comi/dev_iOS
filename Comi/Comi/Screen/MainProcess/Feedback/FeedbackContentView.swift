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
    @State private var value:CGFloat = 0.01
    @State private var showValue: Bool = false
    @State private var scoreColor: Color = .clear

    var body: some View {
        VStack {
            backButton()
            feedBackInterface()
            Spacer()
            Text("분석 화면")
            Spacer()
            ScorePieChart(value: $value, showValue: $showValue, scoreColor: $scoreColor)
            Spacer()
        }.background(BackGround())
    }

    @ViewBuilder
    private func backButton() -> some View {
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
            VStack(spacing: 16) {
                Text("날짜 조정해야함")
                    .font(.ptRegular14)
                    .foregroundStyle(.cwhite)

                VStack {
                    HStack {
                        Spacer()
                        Button {
                            withAnimation {
                                checkType = false
                            }
                        } label: {
                            Text("발음")
                                .font(.ptRegular18)
                                .foregroundStyle(checkType ? .cwhite : .blue1)
                        }
                        Spacer()
                        Spacer()
                        Button {
                            withAnimation {
                                checkType = true
                            }
                        } label: {
                            Text("어휘")
                                .font(.ptRegular18)
                                .foregroundStyle(checkType ? .blue1 : .cwhite)
                        }
                        Spacer()
                    }
                        .padding(.horizontal, 32)
                    ZStack {
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                            .fill(.disabled)
                            .padding(.horizontal, 32)
                            .frame(height: 8)
                        RoundedRectangle(cornerRadius: 100, style: .continuous)
                            .fill(.blue1)
                            .frame(width: 139, height: 8)
                            .offset(x: checkType ? 71 : -71)
                    }
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: 110)
            .padding(.horizontal, 24)
    }
}

#Preview {
    FeedbackContentView()
}
