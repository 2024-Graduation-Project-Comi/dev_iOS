//
//  FeedBackBottomButton.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import SwiftUI
struct FeedbackBottomButton: View {

    @Binding var currentPage: Int
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
                        currentPage == 3 ? LinearGradient(
                            stops: [
                                Gradient.Stop(color: .blue2, location: 0.00),
                                Gradient.Stop(color: .blue1, location: 1.00)
                            ],
                            startPoint: UnitPoint(x: 0, y: 1),
                            endPoint: UnitPoint(x: 1, y: 0)
                        ):
                            LinearGradient(
                            stops: [
                                Gradient.Stop(color: .disabled2, location: 1.00)
                            ],
                            startPoint: UnitPoint(x: 0, y: 1),
                            endPoint: UnitPoint(x: 1, y: 0)
                        )
                    )
                        .cornerRadius(100)
                        .padding(.horizontal, 24)
                    Text(title)
                        .font(.ptSemiBold18)
                        .foregroundStyle(currentPage == 3 ? .cwhite : .constantsSemi)
                }
            })
            .disabled(currentPage == 3 ? false : true)
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
