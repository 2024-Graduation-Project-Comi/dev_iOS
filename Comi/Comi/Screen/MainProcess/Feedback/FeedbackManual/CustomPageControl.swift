//
//  CustomPageControl.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import SwiftUI

struct CustomPageControl: View {

    @Binding var currentPage: Int
    @Binding var isAnimation: Bool
    let numberOfPages: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .fill(.white)
                .frame(width: 112, height: 24)
            HStack(spacing: 8) {
                ForEach(0..<numberOfPages, id: \.self) { page in
                    Image(systemName: page == currentPage ? "minus" : "circle.fill")
                        .resizable()
                        .frame(width: page == currentPage ? 40 : 8, height: 8)
                        .foregroundColor(page == currentPage ? .blue2 : .unavailableCircle)
                        .animation(.easeInOut, value: isAnimation)
                }
            }
        }
    }
}

#Preview {
    CustomPageControl(currentPage: .constant(0), isAnimation: .constant(false), numberOfPages: 3)
}
