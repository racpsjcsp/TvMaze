//
//  TVShow.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation

struct TVShow: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let image: ImageURL?
    let summary: String?
    let genres: [String]
    let schedule: Schedule?

    var cleanedSummary: String? {
        summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }

    var genresText: String? {
        guard !genres.isEmpty else { return nil }
        return genres.joined(separator: ", ")
    }

    var scheduleText: String? {
        guard let time = schedule?.time, !schedule!.days.isEmpty else { return nil }
        return "\(schedule!.days.joined(separator: ", ")) at \(time)"
    }

    struct Schedule: Codable, Equatable {
        let time: String
        let days: [String]
    }

    struct ImageURL: Codable, Equatable {
        let medium: String?
        let original: String?
    }
}

struct SearchResult: Codable {
    let show: TVShow
}
