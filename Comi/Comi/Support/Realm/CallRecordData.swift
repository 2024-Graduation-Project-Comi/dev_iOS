//
//  CallRecordData.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import RealmSwift

class CallRecordData: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: Int // callID
    @Persisted var modelId: Int
    @Persisted var topic: String
    @Persisted var convCount: Int
    @Persisted var ended: Date
    @Persisted var times: String
}

class CallRecordViewModel: ObservableObject {

    @Published var models: [RealmCallRecord]

    init() {
        self.models = []
        fetchData()
    }

    func setData(callRecordData: CallRecords) {
        do {
            let realm = try Realm()
            let realmData = CallRecordData()
            realmData.id = callRecordData.callId
            realmData.modelId = callRecordData.modelId
            realmData.topic = callRecordData.topic
            realmData.convCount = callRecordData.convCnt ?? 0
//            {
//                guard let value = callRecordData.convCnt else {
//                    return 0
//                }
//                if value <= 1 {
//                    return 0
//                } else {
//                    return value
//                }
//            }()
            realmData.ended = callRecordData.ended
            realmData.times = RealmViewModel.shared.millisecondsToMMSS(milliseconds: callRecordData.times)
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
            let target = realm.objects(CallRecordData.self)
            let arrData = Array(target)
            var trans: [RealmCallRecord] = []
            for data in arrData {
                let temp = RealmCallRecord(
                    id: data.id,
                    modelId: data.modelId,
                    topic: data.topic,
                    convCount: data.convCount,
                    ended: data.ended,
                    times: data.times
                )
                trans.append(temp)
            }
            models = trans
        } catch {
            print(error)
        }
    }
    func copySupaData() {
        Task {
            let userId = await RealmViewModel.shared.userData.models.userId
            print("copyTest userID : \(userId)")
            let datas = await CallRecordsDB.shared.getData()
            for data in datas {
                setData(callRecordData: data)
            }
            fetchData()
            print("CallRecord copy success")
        }
    }

    func readyData() {
        if checkDB(type: .callRecordData) {
            Task {
//                copySupaData()
            }
        } else {
            fetchData()
        }
        print("CallRecord Ready")
    }

    func updateData(id: Int) {
        Task {
            let datas = await CallRecordsDB.shared.getData(id: id)
            for data in datas {
                setData(callRecordData: data)
            }
            fetchData()
            print("CallRecord Update success")
        }
    }

}
