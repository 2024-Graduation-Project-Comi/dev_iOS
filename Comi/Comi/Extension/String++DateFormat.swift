//
//  String++DateFormat.swift
//  Comi
//
//  Created by yimkeul on 5/26/24.
//

import Foundation

extension String {
    func toKoreanDateFormat() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        // 여러 포맷 시도
        let formats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX",
            "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        ]

        var date: Date?
        for format in formats {
            dateFormatter.dateFormat = format
            if let parsedDate = dateFormatter.date(from: self) {
                date = parsedDate
                break
            }
        }
        guard let validDate = date else { return nil }

        let koreanDateFormatter = DateFormatter()
        koreanDateFormatter.locale = Locale(identifier: "ko_KR")
        koreanDateFormatter.dateFormat = "yyyy년 MM월 dd일"

        return koreanDateFormatter.string(from: validDate)
    }
}
