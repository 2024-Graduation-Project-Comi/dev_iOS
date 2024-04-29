//
//  BackGround.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct BackGround: View {
    var body: some View {
        GeometryReader { geo in
            let size = geo.size
            VStack {
                Spacer()
                Circle()
                    .frame(width: size.width)
                    .foregroundStyle(.blue0)
                    .offset(y: size.height/3)
                    .blur(radius: 10)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        
    }
}

#Preview {
    BackGround()
}
