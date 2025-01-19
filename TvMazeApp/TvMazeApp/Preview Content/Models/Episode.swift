//
//  Episode.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation

struct Episode: Identifiable, Codable {
    let id: Int
    let name: String
    let season: Int
    let number: Int
    let airdate: String?
    let airtime: String?
    let image: ImageURL?
    let summary: String?

    var cleanedSummary: String? {
        summary?.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }

    struct ImageURL: Codable {
        let medium: String?
        let original: String?
    }
}
