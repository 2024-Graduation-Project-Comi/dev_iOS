//
//  StartProcessData.swift
//  Comi
//
//  Created by yimkeul on 4/29/24.
//

import Foundation

class StartProcessData: ObservableObject {
    @Published var isLogin: Bool = false
    
    func changeLoginState() {
        isLogin = true
    }
}

