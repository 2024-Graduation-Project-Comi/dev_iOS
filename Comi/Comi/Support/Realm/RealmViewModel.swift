//
//  RealmViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import RealmSwift
import SwiftUI

class RealmViewModel: ObservableObject {

    @ObservedObject var modelData = ModelViewModel()
    @ObservedObject var callRecordData = CallRecordViewModel()

    func start() async {
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        modelData.readyData()
        callRecordData.readyData()
    }

    func findModelInfo(modelId: Int) -> RealmModel? {
        let modelsRealm = ModelViewModel()

        if checkDB(type: .modelData) {
            modelsRealm.copySupaData()
        } else {
            modelsRealm.fetchData()
        }

        let modelsDatas: [RealmModel] = modelsRealm.models
        guard let result = modelsDatas.first(where: { $0.id == modelId }) else {
            return nil
        }
        return result
    }
}

struct RealmModel: Codable, Hashable {
    var id: Int
    var name: String
    var group: String?
    var state: RealmModelState
    var image: String
}

enum RealmModelState: Int, Codable {
    case available = 0
    case unavailable = 1
    case locked = 2
}

struct RealmCallRecord: Hashable {
    var id: Int
    var modelId: Int
    var topic: String
    var convCount: Int
    var ended: Date
    var times: String
}

enum RealmType {
    case modelData
    case callRecordData

    var objectType: Object.Type {
        switch self {
        case .modelData:
            return ModelData.self
        case .callRecordData:
            return CallRecordData.self
        }
    }
}

func checkDB(type: RealmType) -> Bool {
    do {
        let realm = try Realm()
        let target = realm.objects(type.objectType)
        if target.isEmpty {
            print("model DB is null ")
        } else {
            print("model DB has data")
        }
        return target.isEmpty
    } catch {
        print(error)
        return true
    }
}
