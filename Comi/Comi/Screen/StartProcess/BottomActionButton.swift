//
//  BottomActionButton.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI

struct BottomActionButton: View {

    var action: () -> Void
    var title: String

    var body: some View {
        VStack {
            Button(action: {
                action()
            }, label: {
                ZStack {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(maxWidth: .infinity, maxHeight: 62)
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
                        .padding(.horizontal, 24)
                    Text(title)
                        .font(.ptSemiBold18)
                        .foregroundStyle(.cwhite)
                }
            })
        }
        .frame(maxWidth: .infinity, minHeight: 82, maxHeight: 82, alignment: .center)
            .background {
            Rectangle()
                .fill(.cwhite)
                .cornerRadius(32, corners: [.topLeft, .topRight])
                .ignoresSafeArea()
        }
    }
}

#Preview {
    BottomActionButton(action: { }, title: "테스트")
}
