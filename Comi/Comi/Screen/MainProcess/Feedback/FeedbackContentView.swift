//
//  FeedbackContentView.swift
//  Comi
//
//  Created by yimkeul on 5/5/24.
//

import SwiftUI
import Charts

struct FeedbackContentView: View {

    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var realmViewModel: RealmViewModel
    @State private var checkType: Bool = false
    @State private var checkTypeNonAnimation: Bool = false
    // 원형 그래프 변수
    // TODO: value state 수정 필요
    @State private var value: Int = 0
    @State private var showValue: Bool = false
    @State private var scoreColor: Color = .clear
    // 사용자 학습 그래프 선택
    @State private var selectedScore: String = "Pronunciation Score"
    @State private var graphData: [GroupProcessData] = []
    @StateObject private var staticViewModel = StaticViewModel()
    var ended: String
    var totalScores: ChartData?

    var body: some View {
        VStack {
            customNavBar()
            feedBackInterface

            ScrollView(showsIndicators: false) {
                Spacer().frame(height: 32)
                switch checkTypeNonAnimation {
                case true:
                    EmptyView()
                case false:
                    pronunciationView
                }
            }
                .padding(.horizontal, 24)
                .background(.clear)
            Spacer()
        }
            .onAppear {
            value = totalScores?.Pronunciation_score ?? 88

            let userID = realmViewModel.userData.models.userId
            staticViewModel.fetchGraphData(userID: userID, completion: { result in
                if result {
                    graphData = staticViewModel.processResult
                    print("Success : ", result)
                } else {
                    print("false")
                }
            })
        }
            .background(BackGround())
    }

    @ViewBuilder
    private var pronunciationView: some View {
        VStack {
            Text("코미의 총점은?")
                .font(.ptSemiBold18)
                .foregroundStyle(.black)
            Text("전체적인 발음 평가입니다")
                .font(.ptRegular11)
                .foregroundStyle(.constantsSemi)

            ScorePieChart(value: $value, showValue: $showValue, scoreColor: $scoreColor)
                .onTapGesture {
                selectedScore = "Pronunciation Score"
            }
                .padding(.top, 8)
                .padding(.bottom, 40)

            HStack {
                scoreCard(title: .Accuracy, desc: "발음 정확도",
                          score: totalScores?.Accuracy_score ?? 10)
                    .onTapGesture {
                    selectedScore = "Accuracy Score"
                }
                scoreCard(title: .Fluency, desc: "자연스러움",
                          score: totalScores?.Fluency_score ?? 88)
                    .onTapGesture {
                    selectedScore = "Fluency Score"
                }
                scoreCard(title: .Prosody, desc: "강세,억양,속도,리듬",
                          score: totalScores?.Prosody_score ?? 90)
                    .onTapGesture {
                    selectedScore = "Prosody Score"
                }
            }
                .padding(.bottom, 40)

            if let selected = graphData.first(where: { $0.label == selectedScore }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(.disabled3)
                    VStack(alignment: .leading) {
                        Text("학습차트")
                            .font(.ptSemiBold14)
                            .foregroundStyle(.black)
                        Picker("", selection: $selectedScore) {
                            Text("총점")
                                .tag("Pronunciation Score")
                            Text("정확도")
                                .tag("Accuracy Score")
                            Text("유창성")
                                .tag("Fluency Score")
                            Text("운율")
                                .tag("Prosody Score")
                        }.pickerStyle(.segmented)
                        Chart(selected.datas, id: \.self) { data in
                            LineMark(
                                x: .value("Date", data.date),
                                y: .value("Values", data.value)
                            )
                        }
                            .padding()
                            .background(.cwhite)
                            .cornerRadius(16, corners: .allCorners)
                            .chartYScale(domain: [0, 100])
                    }
                        .padding()
                }
            }
        }
    }

    @ViewBuilder
    private var feedBackInterface: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
            VStack {
                Text(ended)
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
                            .offset(x: checkType ? size.width / 4 - 4: -size.width / 4 + 4)

                        HStack {
                            Spacer()
                                .frame(width: 68)
                            Button {
                                withAnimation {
                                    checkType = false
                                }
                                checkTypeNonAnimation = false
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
                                checkTypeNonAnimation = true
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
    private func scoreCard(title: FeedbackTypes, desc: String, score: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(.disabled3)
            VStack(spacing: 0) {
                Text(title.rawValue)
                    .font(.ptSemiBold14)
                    .foregroundStyle(.black)
                Text(desc)
                    .font(.ptRegular11)
                    .foregroundStyle(.constantsSemi)
                Spacer().frame(height: 8)
                Text("\(score)")
                    .font(.ptBold48)
                    .foregroundStyle(self.updateScoreColor(for: score))
            }
                .padding(.horizontal, 8)
                .padding(.vertical, 16)
        }
            .frame(width: 108, height: 112)
    }

    func updateScoreColor(for value: Int) -> Color {
        if value == 0 {
            return .clear
        } else if value <= 59 {
            return .red
        } else if value <= 79 {
            return .yellow
        } else {
            return .green
        }
    }
}

//#Preview {
//    FeedbackContentView()
//        .environmentObject(RealmViewModel())
//}
