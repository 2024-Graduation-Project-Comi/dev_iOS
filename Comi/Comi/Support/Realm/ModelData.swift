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

    @Published var models: [Models]

    init() {
        self.models = []
    }

    func setData(modelData: Models) {
        let realm = try! Realm()
        let realmData = ModelData()
        realmData.id = modelData.id
        realmData.name = modelData.name
        if modelData.group != nil {
            realmData.group = modelData.group
        }
        realmData.state = modelData.state.rawValue
        realmData.image = modelData.image

        try! realm.write {
            realm.add(realmData)
        }
    }

    func checkDB() -> Bool {
        let realm = try! Realm()
        let target = realm.objects(ModelData.self)
        if target.isEmpty {
            print("model DB is null ")
        } else {
            print("model DB has data")
        }
        return target.isEmpty
    }

    func fetchData() {
        let realm = try! Realm()
        let filteredData = realm.objects(ModelData.self)
        let arrData = Array(filteredData)
        var trans: [Models] = []
        for data in arrData {
            let temp = Models(id: data.id, name: data.name, group: data.group ?? nil, state: ModelState(rawValue: data.state) ?? .available, image: "")
            trans.append(temp)
        }
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        models = trans
        print(models)
    }

    func copySupaData() {
        Task {
            let datas = await ModelsDB.shared.getData()
            for data in datas {
                setData(modelData: data)
            }
            fetchData()
            print("copy success")
        }
    }

}
