//
//  Artist.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation

struct Artist: Identifiable, Codable {
    let id: Int
    let name: String
    let image: ImageURL?
    let shows: [TVShow]

    var imageURL: String? {
        image?.medium ?? image?.original
    }

    struct ImageURL: Codable {
        let medium: String?
        let original: String?
    }
}

struct ArtistSearchResult: Codable {
    let person: ArtistPerson
    let embedded: EmbeddedShows?

    enum CodingKeys: String, CodingKey {
        case person
        case embedded = "_embedded"
    }
}

struct ArtistPerson: Codable {
    let id: Int
    let name: String
    let image: Artist.ImageURL?
}

struct EmbeddedShows: Codable {
    let shows: [TVShow]
}
