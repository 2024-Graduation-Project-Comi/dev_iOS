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
