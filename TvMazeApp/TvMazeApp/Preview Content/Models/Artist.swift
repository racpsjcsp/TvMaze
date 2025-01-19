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

struct ArtistDetailsResponse: Decodable {
    let id: Int
    let name: String
    let image: ImageInfo?
    let embedded: EmbeddedCastCredits
    let links: Links

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case embedded = "_embedded"
        case links = "_links"
    }
}

struct ImageInfo: Decodable {
    let medium: String?
    let original: String?
}

struct EmbeddedCastCredits: Decodable {
    let castCredits: [CastCredit]

    enum CodingKeys: String, CodingKey {
        case castCredits = "castcredits"
    }
}

struct CastCredit: Decodable {
    let id: Int
    let show: TVShow?
}

struct Links: Codable {
    let show: ShowLink

    enum CodingKeys: String, CodingKey {
        case show = "show"
    }
}

struct ShowLink: Codable {
    let href: String
    let name: String
}

