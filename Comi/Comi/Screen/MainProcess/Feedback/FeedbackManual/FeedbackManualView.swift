//
//  FeedbackManualView.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import SwiftUI

struct FeedbackManualView: View {
    @Binding var currentPage: Int
    @Binding var isAnimation: Bool
    let content: FeedbackSet
    var body: some View {
        VStack(spacing: 0) {
            Text(content.title)
                .font(.ptSemiBold32)
                .padding(.top, 80)
                .padding(.bottom, 12)
            Text(content.subDec1)
                .font(.ptRegular14)
                .foregroundStyle(.constantsSemi)
            Text(content.subDec2 ?? "  ")
                .font(.ptRegular14)
                .foregroundStyle(.constantsSemi)
            Image(content.image)
                .padding(.top, 40)
        }.onAppear {
            isAnimation.toggle()
        }
    }
}
