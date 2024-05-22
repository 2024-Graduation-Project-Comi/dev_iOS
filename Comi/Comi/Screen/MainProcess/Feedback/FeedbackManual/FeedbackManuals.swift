//
//  FeedbackManuals.swift
//  Comi
//
//  Created by yimkeul on 5/22/24.
//

import Foundation
import SwiftUI

struct FeedbackSet {
    let title: String
    let subDec1: String
    let subDec2: String?
    let image: String
}

let FeedbackData: [FeedbackSet] = [
    FeedbackSet(title: "대화 내용 분석", subDec1: "상단의 탭을 눌러 이번 대화를 분석한 내용을 볼 수 있어요.", subDec2: nil, image: "Onboard1"),
    FeedbackSet(title: "대화 저장하기", subDec1: "대화를 폴더에 저장해 나중에 모아서 보실 수 있어요.", subDec2: "(프로필 > 저장된 대화 보기)", image: "Onboard2"),
    FeedbackSet(title: "다른 표현 & 예시", subDec1: "말풍선을 꾹 눌러 하단의 버튼을 이용할 수있어요.", subDec2: "버튼을 통해 다양한 표현을 확인해 보세요.", image: "Onboard3"),
    FeedbackSet(title: "통화 녹음 재생", subDec1: "자동으로 저장되는 통화 내용을 말풍선을 터치해 듣거나,", subDec2: "아래의 플레이어를 재생시켜 전체 내용을 들을 수 있어요.", image: "Onboard4")
]
