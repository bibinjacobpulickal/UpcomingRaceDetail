//
//  ContentModel.swift
//  Entain
//
//  Created by Bibin Jacob Pulickal on 07/12/23.
//

import Foundation

// MARK: - Response
struct Response: Codable {
    let status: Int
    let data: RaceData
    let message: String
}

// MARK: - RaceData
struct RaceData: Codable {
    let nextToGoIDS: [String]
    let raceSummaries: [String: RaceSummary]

    enum CodingKeys: String, CodingKey {
        case nextToGoIDS = "next_to_go_ids"
        case raceSummaries = "race_summaries"
    }
}

// MARK: - RaceSummary
struct RaceSummary: Codable, Identifiable, Equatable {
    let id, raceName, meetingName: String
    let raceNumber: Int
    let categoryID: RaceCategory
    let advertisedStart: AdvertisedStart

    enum CodingKeys: String, CodingKey {
        case id = "race_id"
        case raceName = "race_name"
        case raceNumber = "race_number"
        case categoryID = "category_id"
        case advertisedStart = "advertised_start"
        case meetingName = "meeting_name"
    }
}

// MARK: - AdvertisedStart
struct AdvertisedStart: Codable, Equatable {
    let seconds: Double
}


// MARK: - RaceCategory
enum RaceCategory: String, Codable, CaseIterable {
    case greyhound = "9daef0d7-bf3c-4f50-921d-8e818c60fe61"
    case harness = "161d9be2-e909-4326-8c2c-35ed71fb460b"
    case horse = "4a2788f8-e825-4d36-9894-efd4baf1cfae"

    var name: String {
        switch self {
        case .greyhound:
            return "Greyhound"
        case .harness:
            return "Harness"
        case .horse:
            return "Horse"
        }
    }
}
