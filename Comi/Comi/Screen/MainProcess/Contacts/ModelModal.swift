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
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: maxSize.width, height: showTopics ? maxSize.height * 0.9 : 264)
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
                    Spacer().frame(height: 16)
                }
                    .padding(EdgeInsets(top: 48, leading: 24, bottom: 0, trailing: 24))
                Spacer().frame(height: 116)
            }
                .frame(width: maxSize.width, height: showTopics ? maxSize.height * 0.9 : 264)
                .opacity(showTopics ? 1 : 0)

            VStack {
                Text(model.name)
                    .font(.ptSemiBold18)
                // TODO: player로 수정
                RoundedRectangle(cornerRadius: 100, style: .continuous)
                    .frame(width: 240, height: 28)
                Spacer()
            }
                .offset(y: 32)
                .frame(width: maxSize.width, height: showTopics ? maxSize.height * 0.9 : 264)
                .opacity(showTopics ? 0 : 1)
        }
            .animation(.easeInOut(duration: 0.5), value: showTopics)
            .onTapGesture {
            showTopics.toggle()
            if showTopics == false {
                close()
            }

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
