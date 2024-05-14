//
//  RealmSampleCode.swift
//  Comi
//
//  Created by yimkeul on 5/14/24.
//

import Foundation

// MARK: Update
//do {
//    let realm = try Realm()
//    
//    // 데이터를 가져와서 필터링
//    let task = realm.objects(RealmEntityTask.self)
//        .filter { $0.id == id }
//    // 데이터 쓰기
//    try realm.write {
//        task.first?.title = title
//        task.first?.desc = description
//        task.first?.deadline = deadline.timeIntervalSince1970
//    }
//} catch let error {
//    print(error)
//}

// MARK: Delete
//do {
//    let realm = try Realm()
//    
//    // 데이터를 가져와서 필터링
//    let task = realm.objects(RealmEntityTask.self)
//        .filter { $0.id == id }
//    // 데이터 삭제
//    try realm.write {
//        realm.delete(task.first ?? task[0])
//    }
//} catch let error {
//    print(error)
//}
