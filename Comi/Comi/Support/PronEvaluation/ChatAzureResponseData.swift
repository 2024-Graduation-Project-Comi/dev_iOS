//
//  Azure.swift
//  Comi
//
//  Created by MoonGoon on 5/24/24.
//

import Foundation

struct ChatAzureResponseData: Codable {
    var text: String
    var accuracyScore: Double
    var pronunciationScore: Double
    var completenessScore: Double
    var fluencyScore: Double
    var prosodyScore: Double
}

struct AzureAverageScore: Codable {
    let accuracyScore: Double?
    let pronunciationScore: Double?
    let completenessScore: Double?
    let fluencyScore: Double?
    let prosodyScore: Double?

    enum CodingKeys: String, CodingKey {
        case accuracyScore = "Accuracy_score"
        case pronunciationScore = "Pronunciation_score"
        case completenessScore = "Completeness_score"
        case fluencyScore = "Fluency_score"
        case prosodyScore = "Prosody_score"
    }
}
