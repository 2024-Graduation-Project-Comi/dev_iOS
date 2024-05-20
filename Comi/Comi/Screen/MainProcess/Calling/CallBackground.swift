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
            }
            if status == .ai {
                Circle()
                    .foregroundStyle(.pink0)
                    .frame(width: 480, height: 480)
                    .offset(x: (-480 / 2))
                Circle()
                    .foregroundStyle(.pink1)
                    .frame(width: 280, height: 280)
                    .offset(x: (-480 / 2))
            }
            if status == .wait || status == .user {
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
            }
        }
            .blur(radius: 40)
            .background(Color.cwhite)
    }
}

#Preview {
    CallBackground(status: .constant(.ready))
}
