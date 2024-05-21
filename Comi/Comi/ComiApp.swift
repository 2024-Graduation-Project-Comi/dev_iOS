//
//  ComiApp.swift
//  Comi
//
//  Created by yimkeul on 3/11/24.
//

import SwiftUI

@main
struct ComiApp: App {
    @StateObject var realmViewModel = RealmViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(realmViewModel)
        }
    }
}
