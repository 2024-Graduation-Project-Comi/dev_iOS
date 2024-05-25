//
//  ScorePieChart.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import SwiftUI

struct ScorePieChart: View {

    @Binding var value: Int
    @Binding var showValue: Bool
    @Binding var scoreColor: Color

    var body: some View {
        ZStack {
            Color.clear
            Circle()
                .stroke(lineWidth: 38)
                .frame(width: 270, height: 270)
                .foregroundStyle(.disabled2)
            Circle()
                .fill(.white)
                .frame(width: 232, height: 232)

            Circle()
                .trim(from: 0, to: showValue ? CGFloat(value) / 100.0 : 0.01)
                .stroke(style: StrokeStyle(lineWidth: 38, lineCap: .round))
                .frame(width: 270, height: 270)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(self.gradientForValue(value))
            if showValue {
                Text("\(value)")
                    .font(.ptSemiBold112)
                    .foregroundStyle(scoreColor)
            }
        }
        .padding()
            .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showValue = true
                    updateScoreColor(for: value)
                }
            }
        }
    }

    func gradientForValue(_ value: Int) -> LinearGradient {
        let gradient: Gradient
        if value <= 59 {
            gradient = Gradient(colors: [.red])
        } else if value <= 79 {
            gradient = Gradient(colors: [.yellow])
        } else {
            gradient = Gradient(colors: [.green])
        }
        return LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    func updateScoreColor(for value: Int) {
        if value == 1 {
            scoreColor = .clear
        } else if value <= 59 {
            scoreColor = .red
        } else if value <= 79 {
            scoreColor = .yellow
        } else {
            scoreColor = .green
        }
    }
}

#Preview {
    ScorePieChart(value: .constant(30), showValue: .constant(false), scoreColor: .constant(.clear))
}
