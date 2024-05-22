//
//  ScorePieChart.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import SwiftUI

struct ScorePieChart: View {

    @Binding var value: CGFloat
    @Binding var showValue: Bool
    @Binding var scoreColor: Color

    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 38)
                .frame(width: 270, height: 270)
                .foregroundStyle(.unavailableCircle)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 10, y: 10)
            Circle()
                .fill(.white)
                .frame(width: 232, height: 232)

            Circle()
                .trim(from: 0, to: showValue ? value : 0.01)
                .stroke(style: StrokeStyle(lineWidth: 38, lineCap: .round))
                .frame(width: 270, height: 270)
                .rotationEffect(.degrees(-90))
                .foregroundStyle(self.gradientForValue(value))
            if showValue {
                Text("\(Int(value * 100))")
                    .font(.ptSemiBold112)
                    .foregroundStyle(scoreColor)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation {
                    showValue.toggle()
                    if showValue {
                        value = 0.79
                    }
                    updateScoreColor(for: value)
                }
            }
        }
    }

    func gradientForValue(_ value: CGFloat) -> LinearGradient {
        let gradient: Gradient
        if value <= 0.59 {
            gradient = Gradient(colors: [.red])
        } else if value <= 0.79 {
            gradient = Gradient(colors: [.yellow])
        } else {
            gradient = Gradient(colors: [.green])
        }
        return LinearGradient(gradient: gradient, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    func updateScoreColor(for value: CGFloat) {
        if value == 0.01 {
            scoreColor = .clear
        } else if value <= 0.59 {
            scoreColor = .red
        } else if value <= 0.79 {
            scoreColor = .yellow
        } else {
            scoreColor = .green
        }
    }
}

#Preview {
    ScorePieChart(value: .constant(0.3), showValue: .constant(false), scoreColor: .constant(.clear))
}
