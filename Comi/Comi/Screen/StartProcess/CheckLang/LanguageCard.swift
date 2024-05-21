//
//  LanguageCard.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import SwiftUI

struct LanguageCard: View {

    @Binding var selected: LanguageData?
    @Binding var isSelect: Bool
    @Binding var userSetting: RealmSetting
    var languageData: LanguageData

    var body: some View {
        ZStack {
            if selected == languageData {
                RoundedRectangle(cornerRadius: 100, style: .continuous)
            }
            Text("\(languageData.localTitle)-\(languageData.globalTitle)")
                .font(.ptRegular14)
                .foregroundStyle(selected == languageData ? .cwhite : .black)
        }
            .frame(maxWidth: .infinity, minHeight: 46, maxHeight: 46)
            .padding(.horizontal, 8)
            .onTapGesture {
            Task {
                selected = selected == languageData ? nil : languageData
                withAnimation(.easeInOut) {
                    isSelect = selected == languageData ? true : false
                }
                userSetting.learning = selected?.globalTitle ?? ""
            }
        }

    }
}

#Preview {
    LanguageCard(selected: .constant(LanguageData(localTitle: "", globalTitle: "")), isSelect: .constant(false), userSetting: .constant(RealmSetting(userId: 0, level: 0, learning: "", local: "")), languageData: LanguageData(localTitle: "", globalTitle: ""))
}
