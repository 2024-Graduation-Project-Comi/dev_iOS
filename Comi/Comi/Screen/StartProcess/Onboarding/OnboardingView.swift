//
//  OnboardindView.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import SwiftUI

struct OnboardingView: View {

    @State private var isStart: Bool = false
    @Binding var isLogin: Bool

    var body: some View {
        if isStart == false {
            GeometryReader { _ in
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

#Preview {
    OnboardingView(isLogin: .constant(false))
}
