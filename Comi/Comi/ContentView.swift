//
//  ContentView.swift
//  Comi
//
//  Created by yimkeul on 3/11/24.
//

import SwiftUI

struct ContentView: View {

    @State private var splashView: Bool = false
    @State var isLogin: Bool = true
    @StateObject var realmViewModel = RealmViewModel()

    var body: some View {
        if splashView {
            if isLogin {
                MainView()
                    .environmentObject(realmViewModel)
            } else {
                OnboardPage(isLogin: $isLogin)
            }

        } else {
            Splash()
                .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    splashView = true
                }
            }
                .environmentObject(realmViewModel)
        }
    }
}

#Preview {
    ContentView()
}
