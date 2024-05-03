//
//  TopicCard.swift
//  Comi
//
//  Created by yimkeul on 5/4/24.
//

import SwiftUI

struct TopicCard: View {
    var data: TopicData
    @Binding var selected: TopicData?
    @Binding var isSelected: Bool
    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.white)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(data.topic.rawValue)
                            .font(.ptSemiBold16)
                        Text(data.desc)
                            .font(.ptRegular14)
                            .foregroundStyle(.constantsSemi)
                    }
                    Spacer()
                }
                    .padding()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(selected == data ? .blue3 : .white, lineWidth: 2)
            }
            .padding(2)
        }
            .frame(maxWidth: .infinity, minHeight: 78, maxHeight: 78)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                selected = selected == data ? nil : data
                isSelected = selected == data ? true : false
            }
        }

    }
}

