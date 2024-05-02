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
    @State private var offset: CGFloat = 0

    private func close() {
        withAnimation(.easeInOut) {
            offset = 1000
            state = false
        }
    }

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
            // TODO: 변경하기
            ScrollView {
                Text(data.name)
                    .font(.ptSemiBold18)
                Text("\(data.id) : \(data.state)")
                    .font(.ptRegular14)
                Divider()
                Text(data.name)
                    .font(.ptSemiBold18)
                Text("\(data.id) : \(data.state)")
                    .font(.ptRegular14)
                Divider()
                Text(data.name)
                    .font(.ptSemiBold18)
                Text("\(data.id) : \(data.state)")
                    .font(.ptRegular14)
                Divider()
            }.padding(EdgeInsets(top: 48, leading: 24, bottom: 0, trailing: 24))
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
}



#Preview {
    ModelModalView(data: Model(id: 0, name: "kari", state: .available), maxHeight: 600, state: .constant(true))
}
