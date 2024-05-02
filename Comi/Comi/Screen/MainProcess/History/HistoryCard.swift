//
//  HistoryCard.swift
//  Comi
//
//  Created by yimkeul on 4/30/24.
//

import SwiftUI

struct HistoryCard: View {
    var data: HistoryData
    @Binding var selected: Int?
    @State private var recentedDate = ""
    @State private var animated: Bool = false
    @State private var isMore: Bool = false
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                .fill(.cardBG)
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(data.conv_count == nil ? data.model.name : "\(data.model.name)(\(Int(data.conv_count!)))")
                            .font(.ptSemiBold18)
                        Text("\(data.topic.rawValue) · \(data.times)")
                            .font(.ptRegular14)
                    }
                    Spacer()
                    Text(recentedDate)
                        .font(.ptRegular14)
                        .foregroundStyle(.constantsSemi)

                }
                if selected == data.call_id {
                    moreFunc()
                }
            }.padding(16)

        }
        .frame(maxWidth: .infinity, minHeight: 78)
            .padding(.bottom, 8)
            .onTapGesture {
            withAnimation {
                selected = selected == data.call_id ? nil : data.call_id
            }
        }
            .onAppear(perform: {
            recentedDate = formatDate(data: data.ended)
        })
    }

}

@ViewBuilder
private func moreFunc() -> some View {
    HStack {
        Button {
            print("채팅")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .fill(.blue2)

                HStack(spacing: 0) {
                    Image("Chat")
                        .padding(.trailing, 20)
                    Text("채팅보기")
                        .font(.ptRegular18)
                        .foregroundStyle(.white)
                }
            }
                .frame(width: 151, height: 48)
        }
        Button {
            print("전화")
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/)
                    .fill(.blue2)
                    .opacity(0.87)

                HStack(spacing: 0) {
                    Image("Call")
                        .padding(.trailing, 20)
                    Text("전화하기")
                        .font(.ptRegular18)
                        .foregroundStyle(.white)
                }
            }.frame(width: 151, height: 48)
        }
    }
}
