//
//  ModelData.swift
//  Comi
//
//  Created by yimkeul on 5/12/24.
//

import Foundation
import RealmSwift

class ModelData: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var name: String
    @Persisted var group: String?
    @Persisted var state: Int
    @Persisted var image: String
}

class ModelViewModel: ObservableObject {

    @Published var models: [RealmModel]

    init() {
        self.models = []
    }

    func setData(modelData: Models) {
        do {
            let realm = try Realm()
            let realmData = ModelData()
            realmData.id = modelData.id
            realmData.name = modelData.name
            if modelData.group != nil {
                realmData.group = modelData.group
            }
            realmData.state = modelData.state.rawValue
            realmData.image = modelData.image

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
            let target = realm.objects(ModelData.self)
            let arrData = Array(target)
            var trans: [RealmModel] = []
            for data in arrData {
                let temp = RealmModel(id: data.id, name: data.name, group: data.group ?? nil, state: RealmModelState(rawValue: data.state) ?? .unavailable, image: data.image)
                trans.append(temp)
            }
            models = trans
        } catch {
            print(error)
        }
    }

    func copySupaData() {
        Task {
            let datas = await ModelsDB.shared.getData()
            for data in datas {
                setData(modelData: data)
            }
            fetchData()
            print("Modle copy success")
        }
    }

    func readyData() {
        if checkDB(type: .modelData) {
            Task {
                copySupaData()
            }
        } else {
            fetchData()
        }
        print("Model Ready")
    }

}
