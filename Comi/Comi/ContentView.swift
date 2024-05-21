//
//  ContentView.swift
//  Comi
//
//  Created by yimkeul on 3/11/24.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject var realmViewModel: RealmViewModel
    @State private var splashView: Bool = false
    @State var isLogin: Bool = false
    @State var isReady: Bool = false

    var body: some View {
        if splashView {
            if isLogin && isReady {
                MainView()
//                    .environmentObject(realmViewModel)
            } else {
                LoginView(isLogin: $isLogin, isReady: $isReady)
                    .environmentObject(realmViewModel)
            }

        } else {
            SplashView()
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    splashView = true
                    isLogin = realmViewModel.userData.models.isLogin
                }
            }
                .environmentObject(realmViewModel)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(RealmViewModel())
}
