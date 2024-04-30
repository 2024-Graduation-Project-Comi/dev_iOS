//
//  HistoryData.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import Foundation

struct HistoryData {
    let call_id: Int // id
    let user_id: Int // 유저 정보
    let model: Model // 모델 정보
    let topic: topics //주제
    let conv_count: Int? // 중복
    let ended: Date // 최근 기록
    let times: String //이용시간, ms단위
}

struct Model {
    var id: Int
    var name: String
    var group: String?
}

let Models:[Model] = [
    Model(id: 0, name: "카리나", group: "에스파"),
    Model(id: 1, name: "윈터", group: "에스파"),
    Model(id: 2, name: "닝닝", group: "에스파"),
    Model(id: 3, name: "지젤", group: "에스파"),
    Model(id: 4, name: "마젠타", group: "qwer"),
    Model(id: 5, name: "히나", group: "qwer"),
    Model(id: 6, name: "쵸단", group: "qwer"),
    Model(id: 7, name: "시연", group: "qwer")
]

enum topics: String {
    case 연애
    case 시사
    case 운동
}



var sampleHistoryData: [HistoryData] = [
    HistoryData(call_id: 0, user_id: 0, model: Model(id: 0, name: "카리나", group: "에스파"), topic: .시사, conv_count: nil, ended: .now , times: millisecondsToMMSS(milliseconds: 230000)),
    HistoryData(call_id: 1, user_id: 0, model: Model(id: 1, name: "윈터", group: "에스파"), topic: .연애, conv_count: 3, ended: Calendar.current.date(from: DateComponents(year:2021, month: 7, day: 1))!, times: millisecondsToMMSS(milliseconds: 230000)),
    HistoryData(call_id: 2, user_id: 0, model: Model(id: 2, name: "닝닝", group: "에스파"), topic: .운동, conv_count: nil, ended: Calendar.current.date(from: DateComponents(year:2021, month: 7, day: 1))!, times: millisecondsToMMSS(milliseconds: 230000)),
    HistoryData(call_id: 3, user_id: 0, model: Model(id: 3, name: "지젤", group: "에스파"), topic: .시사, conv_count: nil, ended: Calendar.current.date(from: DateComponents(year:2021, month: 7, day: 1))!, times: millisecondsToMMSS(milliseconds: 230000)),
    HistoryData(call_id: 4, user_id: 0, model: Model(id: 4, name: "마젠타", group: "qwer"), topic: .운동, conv_count: nil, ended: Calendar.current.date(from: DateComponents(year:2021, month: 7, day: 1))!, times: millisecondsToMMSS(milliseconds: 230000)),
    HistoryData(call_id: 5, user_id: 0, model: Model(id: 5, name: "히나", group: "qwer"), topic: .연애, conv_count: nil, ended: Calendar.current.date(from: DateComponents(year:2021, month: 7, day: 1))!, times: millisecondsToMMSS(milliseconds: 230000)),
    HistoryData(call_id: 6, user_id: 0, model: Model(id: 6, name: "쵸단", group: "qwer"), topic: .시사, conv_count: nil, ended: Calendar.current.date(from: DateComponents(year:2021, month: 7, day: 1))!, times: millisecondsToMMSS(milliseconds: 230000))
]

func millisecondsToMMSS(milliseconds: Int) -> String {
    let totalSeconds = milliseconds / 1000
    let minutes = totalSeconds / 60
    let seconds = totalSeconds % 60
    return String(format: "%02d:%02d", minutes, seconds)
}

func formatDate(data: Date) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "ko_kr")
    let currentDate = Date()
    
    let isToday = Calendar.current.isDate(data, inSameDayAs: currentDate)
    
    if isToday {
        // 오늘의 날짜와 같은 경우
        dateFormatter.dateFormat = "a hh:mm"
        let formattedString = dateFormatter.string(from: data)
        return formattedString
    } else {
        // 오늘의 날짜와 다른 경우
        dateFormatter.dateFormat = "yyyy.MM.dd"
        let formattedString = dateFormatter.string(from: data)
        return formattedString
    }
}




