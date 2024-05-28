//
//  UsersDB.swift
//  Comi
//
//  Created by yimkeul on 5/28/24.
//

import Foundation
import Supabase

class UsersDB: ObservableObject {

    static var shared = UsersDB()
    @Published var data: [Users]

    init() {
        self.data = []
    }

    let client = SupaClient.shared.setClient()

    func updateData(data: RealmUser) async {
        do {
            let updateData: Users = Users(userId: data.userId, createdAt: data.createdAt.toString(), email: data.email, social: data.social, remainTime: data.remainTime)
            try await client
                .from("Users")
                .update(updateData)
                .eq("user_id", value: data.userId)
                .execute()
            print("succes update login table")
        } catch {
            print(error)
        }
    }

    func insertData(id: Int) async {
        let data = Users(userId: id, createdAt: Date.now.toString(), email: "", social: "0", remainTime: 18000000)
        do {
            try await client
                .from("Users")
                .insert(data)
                .execute()
            print("succes add login table")
        } catch {
            print(error)
        }
    }
}

extension Date {
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssXXXXX"
        return dateFormatter.string(from: self)
    }
}
