//
//  ComiApp.swift
//  Comi
//
//  Created by yimkeul on 3/11/24.
//

import SwiftUI
import AVFoundation

@main
struct ComiApp: App {
    @StateObject var realmViewModel = RealmViewModel()

//    init() {
//        configureAudioSession()
//    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(realmViewModel)
        }
    }
}
