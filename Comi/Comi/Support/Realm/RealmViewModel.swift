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

    static var shared = RealmViewModel()

    @ObservedObject var modelData = ModelViewModel()
    @ObservedObject var callRecordData = CallRecordViewModel()
    @ObservedObject var userData = UserViewModel()
    @ObservedObject var settingData = SettingViewModel()

    func start() async {
        print("realm 위치: ", Realm.Configuration.defaultConfiguration.fileURL!)
        userData.readyData()
        settingData.readyData()
        modelData.readyData()
        callRecordData.readyData()
    }

    func findModelInfo(modelId: Int) -> RealmModel? {
        let modelsDatas: [RealmModel] = modelData.models
        guard let result = modelsDatas.first(where: { $0.id == modelId }) else {
            return nil
        }
        return result
    }

    func millisecondsToMMSS(milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func formatDate(data: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_kr")
        let currentDate = Date()
        let isToday = Calendar.current.isDate(data, inSameDayAs: currentDate)

        if isToday {
            // 오늘의 날짜와 같은 경우
            dateFormatter.dateFormat = "a hh:mm"
            let formattedString = dateFormatter.string(from: data)
            return formattedString
        } else {
            // 오늘의 날짜와 다른 경우
            dateFormatter.dateFormat = "yyyy.MM.dd"
            let formattedString = dateFormatter.string(from: data)
            return formattedString
        }
    }
}

struct RealmModel: Codable, Hashable {
    var id: Int
    var name: String
    var englishName: String
    var group: String?
    var state: RealmModelState
    var image: String

    init() {
        self.id = 0
        self.name = ""
        self.englishName = ""
        self.group = group ?? ""
        self.state = .unavailable
        self.image = ""
    }
    init(id:Int, name:String, englishName: String, group:String?,state: RealmModelState,image: String) {
        self.id = id
        self.name = name
        self.englishName = englishName
        self.group = group ?? ""
        self.state = state
        self.image = image
    }
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

struct RealmUser: Hashable {
    var userId: Int
    var createdAt: Date
    var email: String
    var social: String
    var remainTime: Int
    var isLogin: Bool
    var isReady: Bool
}

struct RealmSetting: Hashable {
    var userId: Int
    var level: Int
    var learning: String
    var local: String
    var globalCode: String
}

// MARK: Realm DB 종류
enum RealmType {
    case modelData
    case callRecordData
    case userData
    case setting

    var objectType: Object.Type {
        switch self {
        case .modelData:
            return ModelData.self
        case .callRecordData:
            return CallRecordData.self
        case .userData:
            return UserData.self
        case .setting:
            return SettingData.self
        }
    }
}

func checkDB(type: RealmType) -> Bool {
    do {
        let realm = try Realm()
        let target = realm.objects(type.objectType)
        if target.isEmpty {
            print("\(type) DB is null ")
        } else {
            print("\(type) DB has data")
        }
        return target.isEmpty
    } catch {
        print(error)
        return true
    }
}
