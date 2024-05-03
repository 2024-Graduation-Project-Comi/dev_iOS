//
//  ModelModalView.swift
//  Comi
//
//  Created by yimkeul on 5/2/24.
//

import SwiftUI

struct ModelModalView: View {
    var data: Model
    var maxHeight: CGFloat
    @Binding var state: Bool
    @Binding var isSelected: Bool
    @State private var offset: CGFloat = 0
    @State private var selected: TopicData?

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 390, height: state ? maxHeight * 0.9 : 264)
                .background(.white.opacity(0.7))
                .cornerRadius(32)
                .overlay(
                RoundedRectangle(cornerRadius: 32)
                    .inset(by: 0.5)
                    .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)
            )
            VStack {
                ScrollView(showsIndicators: false) {
                    ForEach(sampleTopicData, id:\.idx) { data in
                        TopicCard(data: data, selected: self.$selected, isSelected: $isSelected)
                        
                    }
                    Spacer().frame(height: 16)
                }
                .padding(EdgeInsets(top: 48, leading: 24, bottom: 0, trailing: 24))
                Spacer().frame(height: 116)
            }
                .frame(width: 390, height: state ? maxHeight * 0.9 : 264)
                .opacity(state ? 1 : 0)

            VStack {
                Text(data.name)
                    .font(.ptSemiBold18)
                Text("\(data.id) : \(data.state)")
                    .font(.ptRegular14)
                Spacer()
            }
                .offset(y: 32)
                .frame(width: 390, height: state ? maxHeight * 0.9 : 264)
                .opacity(state ? 0 : 1)
        } .animation(.easeInOut(duration: 0.5), value: state)
            .onTapGesture {
            state.toggle()
            if state == false {
                close()
            }

        }
    }
    private func close() {
        withAnimation(.easeInOut) {
            offset = 1000
            state = false
        }
    }
}



#Preview {
    ModelModalView(data: Model(id: 0, name: "kari", state: .available), maxHeight: 600, state: .constant(true), isSelected: .constant(true))
}
