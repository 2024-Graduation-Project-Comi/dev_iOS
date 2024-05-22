//
//  FeedbackManualTabView.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import SwiftUI

struct FeedbackManualTabView: View {
    
    @State private var isAnimation: Bool = false
    @State private var currentPage = 0
    @Binding var isOnboarding: Bool
    let numberOfPages = 4
    let content = FeedbackData

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                FeedbackManualView(currentPage: $currentPage, isAnimation: $isAnimation, content: content[0])
                    .tag(0)
                FeedbackManualView(currentPage: $currentPage, isAnimation: $isAnimation, content: content[1])
                    .tag(1)
                FeedbackManualView(currentPage: $currentPage, isAnimation: $isAnimation, content: content[2])
                    .tag(2)
                FeedbackManualView(currentPage: $currentPage, isAnimation: $isAnimation, content: content[3])
                    .tag(3)
            } .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            CustomPageControl(currentPage: $currentPage, isAnimation: $isAnimation, numberOfPages: numberOfPages)
                .padding(.top, 64)
            FeedbackBottomButton(currentPage: $currentPage, action: {isOnboarding.toggle()}, title: "대화내역 보러가기")
        }
        .background(BackGround())
    }
}

#Preview {
    FeedbackManualTabView(isOnboarding: .constant(false))
}
