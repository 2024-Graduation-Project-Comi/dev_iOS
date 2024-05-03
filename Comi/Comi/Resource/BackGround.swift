//
//  BackGround.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct BackGround: View {
    var body: some View {
        VStack {
            Spacer()
            Circle()
                .frame(width: 480, height: 480)
                .foregroundStyle(.blue0)
                .offset(y: 240)
        }
        .padding(0)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .blur(radius: 20)
        .background(.cwhite)
        .opacity(0.7)
        .ignoresSafeArea()
        
    }
}

#Preview {
    BackGround()
}
