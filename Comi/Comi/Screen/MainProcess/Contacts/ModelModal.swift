//
//  ModelModal.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct ModelModal: View {

    @EnvironmentObject var topics: TopicsDB
    @State private var offset: CGFloat = 0
    @Binding var showTopics: Bool
    @Binding var isSelected: Bool
    @Binding var selected: Topics?
    var model: RealmModel
    var maxSize: CGSize

    var body: some View {
        ZStack(alignment: .top) {
            // TOOD: 음성 재생 기능 추가
//            playSound()

            Rectangle()
                .foregroundColor(.clear)
                .frame(width: maxSize.width, height: showTopics ? maxSize.height * 0.9 : 90)
                .background(.cwhite.opacity(0.7))
                .cornerRadius(32)
                .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)
            )

            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(topics.data, id: \.id) { data in
                        TopicCard(selected: self.$selected, isSelected: $isSelected, topic: data)
                    }
                    Spacer().frame(height: 110)
                }
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
            }
                .frame(width: maxSize.width, height: showTopics ? maxSize.height * 0.9 : 90)
                .opacity(showTopics ? 1 : 0)
        }
            .animation(.easeInOut(duration: 0.5), value: showTopics)
            .onTapGesture {
            showTopics.toggle()
            if showTopics == false {
                close()
            }
        }
    }

    @ViewBuilder
    private func playSound() -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .frame(width: 160, height: 28)
            RoundedRectangle(cornerRadius: 100, style: .continuous)
                .foregroundStyle(.cwhite)
                .frame(width: 100, height: 2)
        }
            .offset(y: showTopics ? 1000 : -40)
            .onTapGesture {
            print("play")
        }
    }

    private func close() {
        withAnimation(.easeInOut) {
            offset = 1000
            showTopics = false
            selected = nil
            isSelected = false
        }
    }
}
