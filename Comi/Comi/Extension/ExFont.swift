//
//  UIFont.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import Foundation
import SwiftUI

extension Font {
    static let ptBold18: Font = .custom("Pretendard-Bold", size: 18)
    static let ptSemiBold18: Font = .custom("Pretendard-SemiBold", size: 18)
    static let ptSemiBold14: Font = .custom("Pretendard-SemiBold", size: 14)
    static let ptSemiBold32: Font = .custom("Pretendard-SemiBold", size: 32)
    static let ptRegular18: Font = .custom("Pretendard-Regular", size: 18)
    static let ptRegular14: Font = .custom("Pretendard-Regular", size: 14)
}
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}