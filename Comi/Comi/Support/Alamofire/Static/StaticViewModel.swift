//
//  StaticViewModel.swift
//  Comi
//
//  Created by yimkeul on 5/24/24.
//

import Foundation
import Alamofire

struct GraphResult: Codable, Hashable {
    var labels: [String]
    var datasets: [GraphData]
}
struct GraphData: Codable, Hashable {
    let label: String
    var data: [Double?]
    let borderColor: String
    let fill: Bool
}

struct GroupProcessData: Hashable {
    var label: String
    var datas: [ProcessedData]
}

struct ProcessedData: Hashable {
    let date: String
    let value: Int
}

enum FeedbackTypes: String {
    case Accuracy = "정확성"
    case Prosody = "운율"
    case Pronunciation = "발음"
    case Completeness = "완성도"
    case Fluency = "유창성"
}

struct ChartData: Codable, Hashable {
    let Accuracy_score: Double?
    let Prosody_score: Double?
    let Pronunciation_score: Double?
    let Completeness_Score: Double?
    let Fluency_score: Double?
    init() {
        Accuracy_score = 0
        Prosody_score = 0
        Pronunciation_score = 0
        Completeness_Score = 0
        Fluency_score = 0
      }
    enum CodingKeys: CodingKey {
        case Accuracy_score
        case Prosody_score
        case Pronunciation_score
        case Completeness_Score
        case Fluency_score
    }
}

class StaticViewModel: ObservableObject {
    @Published var result: GraphResult = .init(labels: [], datasets: [])
    @Published var processResult: [GroupProcessData] = []
    @Published var chartResult: ChartData = .init()

    func fetchGraphData(userID: Int, completion: @escaping (Bool) -> Void) {
        let url = "http://211.216.233.107:88/static/scores/graph\(userID)"
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: GraphResult.self) { response in
            switch response.result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.result = items
                    self.sortGraphData(graphResult: &self.result)
                    self.processResult = self.processGraphData(graphResult: self.result)
//                    print("PROCESS : \(self.processResult)")
                    completion(true)
                }
            case .failure(let error):
                print("Error \(error)")
                completion(false)
            }
        }
    }

    func fetchChartData(callID: Int, completion: @escaping(Bool) -> Void) {
        let url = "http://211.216.233.107:88/static/scores/chart\(callID)"
        AF.request(url, method: .get)
            .validate()
            .responseDecodable(of: ChartData.self) { response in
            switch response.result {
            case .success(let items):
                DispatchQueue.main.async {
                    self.chartResult = items
                    print("ChartResult : \(self.chartResult)")
                    completion(true)
                }
            case .failure(let error):
                print("Error \(error)")
                completion(false)
            }
        }

    }

    func sortGraphData(graphResult: inout GraphResult) {
        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        // labels와 index 매핑 생성
        let indexedLabels = graphResult.labels.enumerated().compactMap { (index, label) -> (index: Int, date: Date)? in
            if let date = dateFormatter.date(from: label) {
                return (index: index, date: date)
            }
            return nil
        }

        // 날짜 오름차순으로 정렬
        let sortedIndexedLabels = indexedLabels.sorted { $0.date < $1.date }

        // 정렬된 labels 생성
        graphResult.labels = sortedIndexedLabels.map { dateFormatter.string(from: $0.date) }

        // 각 dataset의 data 재정렬
        for i in 0..<graphResult.datasets.count {
            let sortedData = sortedIndexedLabels.map { graphResult.datasets[i].data[$0.index] ?? 0 }
            graphResult.datasets[i].data = sortedData
        }
    }
    func processGraphData(graphResult: GraphResult) -> [GroupProcessData] {
        // 날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        // 현재 날짜 설정
        let currentDate = Date()
        let calendar = Calendar.current
        let currentYear = calendar.component(.year, from: currentDate)
        let currentMonth = calendar.component(.month, from: currentDate)

        // 그룹화된 결과 저장
        var groupedResults: [GroupProcessData] = []

        for dataset in graphResult.datasets {
            // 데이터 그룹화
            var yearlyData: [String: [Int]] = [:]
            var monthlyData: [String: [Int]] = [:]
            var dailyData: [String: [Int]] = [:]

            for (index, label) in graphResult.labels.enumerated() {
                guard let date = dateFormatter.date(from: label) else { continue }

                let year = calendar.component(.year, from: date)
                let month = calendar.component(.month, from: date)
                let day = calendar.component(.day, from: date)

                let value = dataset.data[index] ?? 0

                if year < currentYear {
                    yearlyData["\(year)년", default: []].append(Int(value))
                } else if year == currentYear && month < currentMonth {
                    let monthString = "\(month)월"
                    monthlyData[monthString, default: []].append(Int(value))
                } else if year == currentYear && month == currentMonth {
                    dailyData["\(day)일", default: []].append(Int(value))
                }
            }

            // 평균 계산 함수
            func calculateAverage(_ values: [Int]) -> Double {
                guard !values.isEmpty else { return 0.0 }
                let sum = values.reduce(0, +)
                return Double(sum) / Double(values.count)
            }

            // ProcessedData 배열 생성
            var processedData: [ProcessedData] = []

            for (key, values) in yearlyData {
                processedData.append(ProcessedData(date: key, value: Int(calculateAverage(values))))
            }

            for (key, values) in monthlyData {
                processedData.append(ProcessedData(date: key, value: Int(calculateAverage(values))))
            }

            for (key, values) in dailyData {
                processedData.append(ProcessedData(date: key, value: Int(calculateAverage(values))))
            }

            // 결과 정렬
            processedData.sort { $0.date < $1.date }

            // GroupProcessData 생성
            let groupProcessData = GroupProcessData(label: dataset.label, datas: processedData)
            groupedResults.append(groupProcessData)
        }

        return groupedResults
    }
}
