//
//  SettingData.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import Foundation
import RealmSwift

class SettingData: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var level: Int?
    @Persisted var learning: String?
    @Persisted var local: String
}

class SettingViewModel: ObservableObject {

    @Published var models: RealmSetting

    init() {
        self.models = .init(userId: 0, local: "")
    }

    func setData(modelData: RealmSetting) {
        do {
            let realm = try Realm()
            let realmData = SettingData()
            realmData.id = modelData.userId
            realmData.level = modelData.level ?? 0
            realmData.learning = modelData.learning ?? ""
            realmData.local = modelData.local

            try realm.write {
                realm.add(realmData, update: .modified)
            }
        } catch {
            print(error)
        }
    }

    func fetchData() {
        do {
            let realm = try Realm()
            let target = realm.objects(SettingData.self)
            let arrData = Array(target)
            var trans: [RealmSetting] = []
            for data in arrData {
                let temp = RealmSetting(userId: data.id, level: data.level ?? 0, learning: data.learning ?? "", local: data.local)
                trans.append(temp)
            }
            models = trans.first ?? .init(userId: 0, local: "")
        } catch {
            print(error)
        }
    }
    
    func copyData(modelData: RealmSetting) {
        Task {
            setData(modelData: modelData)
            fetchData()
            print("User Setting Copy Success")
        }
    }
    
    func readyData(modelData: RealmSetting) {
        if checkDB(type: .setting) {
            copyData(modelData: modelData)
        } else {
            fetchData()
        }
        print("setting ready")
    }

    func updateData(data: RealmSetting) async {
        updateUserSettingData(data: data)
        fetchData()
        print("User Setting update success")
    }

    func updateUserSettingData(data: RealmSetting) {
        do {
            let realm = try Realm()
            let target = realm.objects(SettingData.self)
                .filter { $0.id == data.userId }

            try realm.write {
                target.first?.level = data.level
                target.first?.learning = data.learning
                target.first?.local = data.local
            }
        } catch {
            print("user setting update 실패")
        }
    }
}
