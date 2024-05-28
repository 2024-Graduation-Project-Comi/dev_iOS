//
//  ServiceLanguage.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import Foundation

struct LanguageData: Hashable {
    let localTitle: String
    let globalTitle: String
    let globalCode: String
}

let languageDatas: [LanguageData] = [
    LanguageData(localTitle: "영어", globalTitle: "English", globalCode: "en"),
    LanguageData(localTitle: "일본어", globalTitle: "日本語", globalCode: "ja"),
    LanguageData(localTitle: "중국어", globalTitle: "中文", globalCode: "cn"),
    LanguageData(localTitle: "프랑스어", globalTitle: "Français", globalCode: "fr")
]
