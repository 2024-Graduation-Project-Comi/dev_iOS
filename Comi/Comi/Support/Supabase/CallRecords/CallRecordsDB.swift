//
//  CallRecordsDB.swift
//  Comi
//
//  Created by yimkeul on 5/13/24.
//

import Foundation
import Supabase

class CallRecordsDB: ObservableObject {

    static var shared = CallRecordsDB()
    @Published var data: [CallRecords]

    init() {
        self.data = []
    }

    let client = SupabaseClient(supabaseURL: URL(string: "https://evurjcnsdykxdkwnlwub.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV2dXJqY25zZHlreGRrd25sd3ViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTMxNTk2MDIsImV4cCI6MjAyODczNTYwMn0.VgrdCMbT-uqJpth4WQm7jcGCg8EAaIBKQcg2D3Hf1vE")

    func getData() async -> [CallRecords] {
        do {
            let datas: [CallRecords] = try await client
                .from("CallRecords")
                .select()
                .execute()
                .value
            return datas
        } catch {
            print(error)
            return []
        }
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
