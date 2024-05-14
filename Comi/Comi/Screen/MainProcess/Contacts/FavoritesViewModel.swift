//
//  FavoritesViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import SwiftUI

class FavoritesViewModel: ObservableObject {
    @AppStorage("favorites") var favoritesModel: Data = Data()
    func decodeSave() -> [RealmModel] {
        if let decodedArray = try? JSONDecoder().decode([RealmModel].self, from: favoritesModel) {
            return decodedArray
        } else {
            return []
        }
    }

    // 배열에 값을 추가하는 메서드
    func encodeSave(value: RealmModel) {
        var currentArray = decodeSave()
        currentArray.append(value)
        if let encodedArray = try? JSONEncoder().encode(currentArray) {
            favoritesModel = encodedArray
        }
    }

    func popIDSave(idx: Int) {
        var currentArray = decodeSave()
        currentArray = currentArray.filter { idx != $0.id }
        if let encodedArray = try? JSONEncoder().encode(currentArray) {
            favoritesModel = encodedArray
        }
    }
}
