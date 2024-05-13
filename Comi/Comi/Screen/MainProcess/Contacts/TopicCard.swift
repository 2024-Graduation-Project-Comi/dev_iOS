//
//  TopicCard.swift
//  Comi
//
//  Created by yimkeul on 5/4/24.
//

import SwiftUI

struct TopicCard: View {

    @Binding var selected: Topics?
    @Binding var isSelected: Bool
    var topic: Topics

    var body: some View {
        ZStack {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(.cwhite)
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(topic.title)
                            .font(.ptSemiBold16)
                        Text(topic.desc)
                            .font(.ptRegular14)
                            .foregroundStyle(.constantsSemi)
                    }
                    Spacer()
                }
                    .padding()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(selected == topic ? .blue3 : .cwhite, lineWidth: 2)
            }
            .padding(2)
        }
            .frame(maxWidth: .infinity, minHeight: 78, maxHeight: 78)
            .onTapGesture {
                withAnimation(.easeInOut(duration: 0.2)) {
                selected = selected == topic ? nil : topic
                isSelected = selected == topic ? true : false
            }
        }

    }
}
