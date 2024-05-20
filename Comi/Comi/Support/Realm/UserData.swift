//
//  UserData.swift
//  Comi
//
//  Created by yimkeul on 5/14/24.
//

import Foundation
import RealmSwift

class UserData: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var userId: Int
    @Persisted var createdAt: Date
    @Persisted var email: String
    @Persisted var social: String
    @Persisted var remainTime: Int
    @Persisted var isLogin: Bool
}

class UserViewModel: ObservableObject {

    @Published var models: RealmUser
    init() {
        self.models = .init(userId: 1, createdAt: Date.now, email: "", social: "", remainTime: 0, isLogin: false)
    }

    // TODO: 수정필요
    func setData() {
        do {
            let realm = try Realm()
            let realmData = UserData()
            realmData.userId = 1
            realmData.createdAt = Date.now
            realmData.email = "example@example.com"
            realmData.social = "sample"
            realmData.remainTime = 300
            realmData.isLogin = false
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
            let target = realm.objects(UserData.self)
            let arrData = Array(target)
            var trans: [RealmUser] = []
            for data in arrData {
                let temp = RealmUser(
                    userId: data.userId,
                    createdAt: data.createdAt,
                    email: data.email,
                    social: data.social,
                    remainTime: data.remainTime,
                    isLogin: data.isLogin
                )
                trans.append(temp)
            }
            models = trans.first ?? RealmUser(userId: 1, createdAt: Date.now, email: "", social: "", remainTime: 0, isLogin: false)
            print("UserData: ", models)
        } catch {
            print(error)
        }
    }

    func copyData() {
        Task {
            setData()
            fetchData()
            print("User copy success")
        }
    }
    func updateData(id: Int) async {
        updateUserLoginData(id: id)
        fetchData()
        print("User update success")
    }
    func readyData() {
        if checkDB(type: .userData) {
            copyData()
        } else {
            fetchData()
        }
        print("user Ready")
    }

    func updateUserLoginData(id: Int) {
        do {
            let realm = try Realm()
            let target = realm.objects(UserData.self)
                .filter { $0.userId == id }
            try realm.write {
                target.first?.createdAt = Date.now
                target.first?.email = "sample@example.com"
                target.first?.social = "sample"
                target.first?.remainTime = 300
                target.first?.isLogin = true
            }
        } catch {
            print("user login udate 실패")
        }
    }

}
