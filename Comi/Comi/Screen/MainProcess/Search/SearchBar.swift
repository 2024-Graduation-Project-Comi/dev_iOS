//
//  SearchBar.swift
//  Comi
//
//  Created by yimkeul on 5/18/24.
//

import SwiftUI

struct SearchBar: View {
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .frame(width: 326, height: 46)
                .overlay {
                HStack {
                    Text("검색")
                        .font(.ptRegular14)
                        .foregroundStyle(.cwhite)
                    Spacer()
                    Image("Search")
                        .foregroundStyle(.cwhite)
                }.padding(.horizontal, 24)
            }
            Spacer()
        }
    }
}

#Preview {
    SearchBar()
}
