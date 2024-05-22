//
//  CallBackground.swift
//  Comi
//
//  Created by yimkeul on 5/4/24.
//

import SwiftUI

struct CallBackground: View {

    @Binding var status: CallState

    var body: some View {
        ZStack {
            if status == .ready {
                ZStack {
                    Circle()
                        .foregroundStyle(.pink0)
                        .frame(width: 480, height: 480)
                        .offset(x: (-480 / 2))
                    Circle()
                        .foregroundStyle(.pink1)
                        .frame(width: 280, height: 280)
                        .offset(x: (-480 / 2))
                    Circle()
                        .foregroundStyle(.callBlue0)
                        .frame(width: 480, height: 480)
                        .offset(x: (480 / 2))
                    Circle()
                        .foregroundStyle(.callBlue1)
                        .frame(width: 280, height: 280)
                        .offset(x: (480 / 2))
                }.blur(radius: 40)
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 292, height: 292)
                  .cornerRadius(292)
                  .overlay(
                    RoundedRectangle(cornerRadius: 292)
                      .inset(by: 1)
                      .stroke(
                        LinearGradient(gradient: Gradient(colors: [Color(red: 0.94, green: 0.19, blue: 1), Color.blue]), startPoint: .leading, endPoint: .trailing),
                        style: StrokeStyle(lineWidth: 2, dash: [5, 5])
                      )
                  )
            }
            if status == .ai {
                ZStack {
                    Circle()
                        .foregroundStyle(.pink0)
                        .frame(width: 480, height: 480)
                        .offset(x: (-480 / 2))
                    Circle()
                        .foregroundStyle(.pink1)
                        .frame(width: 280, height: 280)
                        .offset(x: (-480 / 2))
                }.blur(radius: 40)
            }
            if status == .wait || status == .user {
                ZStack {
                    Circle()
                        .foregroundStyle(.callBlue0)
                        .frame(width: 480, height: 480)
                        .offset(x: (480 / 2))
                    if status == .user {
                        Circle()
                            .foregroundStyle(.callBlue1)
                            .frame(width: 292, height: 292)
                            .offset(x: (480 / 2))
                    }
                }.blur(radius: 40)
            }
        }
            .background(Color.cwhite)
    }
}

#Preview {
    CallBackground(status: .constant(.ready))
}
