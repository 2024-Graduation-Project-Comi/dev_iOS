//
//  OnboardPage.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct OnboardPage: View {
    @State private var isStart: Bool = false
    @Binding var isLogin: Bool
    var body: some View {
        if isStart == false {
            GeometryReader { geo in
                let _ = geo.size

                VStack {
                    // TODO: TabView .page
                    Spacer()
                    BottomStartBtn(isStart: $isStart)
                }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }.background {
                BackGround()
            }
        } else {
            LoginView(isLogin: $isLogin)
        }
        
    }
}

//#Preview {
//    OnboardPage()
//}
