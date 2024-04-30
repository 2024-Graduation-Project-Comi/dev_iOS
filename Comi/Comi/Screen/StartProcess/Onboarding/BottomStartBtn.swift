//
//  BottomStartBtn.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct BottomStartBtn: View {
    @Binding var isStart: Bool
    var body: some View {
        VStack {
            
            Button {
                isStart = true
            } label: {
                ZStack {
                    Rectangle()
                      .foregroundColor(.clear)
                      .frame(width: 342, height: 62)
                      .background(
                        LinearGradient(
                          stops: [
                            Gradient.Stop(color: .blue2, location: 0.00),
                            Gradient.Stop(color: .blue1, location: 1.00),
                          ],
                          startPoint: UnitPoint(x: 0, y: 1),
                          endPoint: UnitPoint(x: 1, y: 0)
                        )
                      )
                      .cornerRadius(100)
                    Text("시작하기")
                        .font(.ptSemiBold18)
                        .foregroundStyle(.white)
                }
            }
        }
            .frame(maxWidth: .infinity, maxHeight: 116, alignment: .center)
            .background {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(.white)
                .ignoresSafeArea()
        }
    }
}


#Preview {
    BottomStartBtn(isStart: .constant(false))
}
