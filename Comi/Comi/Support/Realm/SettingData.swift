//
//  SettingData.swift
//  Comi
//
//  Created by yimkeul on 5/21/24.
//

import Foundation
import RealmSwift

class SettingData: Object, ObjectKeyIdentifiable {
    @Persisted var id: Int
    @Persisted var level: Int
    @Persisted var learning: String
    @Persisted var local: String
}

class SettingViewModel: ObservableObject {

    @Published var models: RealmSetting

    init() {
        self.models = .init(userId: 0, level: 0, learning: "", local: "")
    }

    func setData() {
        do {
            let realm = try Realm()
            let realmData = SettingData()
            realmData.id = 0
            realmData.level = 0
            realmData.learning = ""
            realmData.local = ""
            try realm.write {
                realm.add(realmData)
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
                let temp = RealmSetting(userId: data.id, level: data.level, learning: data.learning, local: data.local)
                trans.append(temp)
            }
            models = trans.first ?? .init(userId: 0, level: 0, learning: "", local: "")
            print("Setting Data : \(models)")
        } catch {
            print(error)
        }
    }

    func copyData() {
        Task {
            setData()
            fetchData()
            print("User Setting Copy Success")
        }
    }

    func readyData() {
        if checkDB(type: .setting) {
            copyData()
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
            guard let target = realm.objects(SettingData.self).first else {
                return
            }
            try realm.write {
                target.id = data.userId
                target.level = data.level
                target.learning = data.learning
                target.local = data.local
            }
        } catch {
            print("user setting update 실패")
        }
    }
}
