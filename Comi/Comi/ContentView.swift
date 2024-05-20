//
//  ContentView.swift
//  Comi
//
//  Created by yimkeul on 3/11/24.
//

import SwiftUI

struct ContentView: View {

    @State private var splashView: Bool = false
    @State var isLogin: Bool = false
    @EnvironmentObject var realmViewModel: RealmViewModel

    var body: some View {
        if splashView {
            if isLogin {
                MainView()
                    .environmentObject(realmViewModel)
            } else {
                LoginView(isLogin: $isLogin)
                    .environmentObject(realmViewModel)
            }

        } else {
            SplashView()
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    splashView = true
                    isLogin = realmViewModel.userData.models.isLogin
                    print("ContentView-Splash 후 isLogin : \(isLogin)")
                }
            }
                .environmentObject(realmViewModel)
        }
    }
}

#Preview {
    ContentView()
}
