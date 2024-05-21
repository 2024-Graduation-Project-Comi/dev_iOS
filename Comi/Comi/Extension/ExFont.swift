//
//  UIFont.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import Foundation
import SwiftUI

extension Font {
    static let ptBold18: Font = .custom("Pretendard-Bold", size: 18 * deviceSizeMultiplier())
    static let ptBold22: Font = .custom("Pretendard-Bold", size: 22 * deviceSizeMultiplier())
    static let ptSemiBold18: Font = .custom("Pretendard-SemiBold", size: 18 * deviceSizeMultiplier())
    static let ptSemiBold16: Font = .custom("Pretendard-SemiBold", size: 16 * deviceSizeMultiplier())
    static let ptSemiBold14: Font = .custom("Pretendard-SemiBold", size: 14 * deviceSizeMultiplier())
    static let ptSemiBold22: Font = .custom("Pretendard-SemiBold", size: 22 * deviceSizeMultiplier())
    static let ptSemiBold32: Font = .custom("Pretendard-SemiBold", size: 32 * deviceSizeMultiplier())
    static let ptRegular18: Font = .custom("Pretendard-Regular", size: 18 * deviceSizeMultiplier())
    static let ptRegular14: Font = .custom("Pretendard-Regular", size: 14 * deviceSizeMultiplier())
    static let ptRegular11: Font = .custom("Pretendard-Regular", size: 11 * deviceSizeMultiplier())
    private static func deviceSizeMultiplier() -> CGFloat {
        let screenWidth = UIScreen.main.bounds.width
        if screenWidth <= 375 {
            return 0.8
        } else if screenWidth >= 428 {
            return 1.1
        } else {
            return 1.0
        }
    }
}
