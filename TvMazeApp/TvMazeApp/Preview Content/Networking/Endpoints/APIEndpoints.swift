//
//  APIEndpoints.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import Foundation

struct APIEndpoints {

    // Base URL for TVMaze API
    private static let baseURL = "https://api.tvmaze.com"

    // Pagination URL for shows (used for fetching pages of shows)
    static func getShowsURL(page: Int) -> String {
        return "\(baseURL)/shows?page=\(page)"
    }

    // Search shows by query
    static func searchShowsURL(query: String) -> String {
        return "\(baseURL)/search/shows?q=\(query)"
    }

    // Get episodes for a specific show by its ID
    static func getEpisodesURL(for showID: Int) -> String {
        return "\(baseURL)/shows/\(showID)/episodes"
    }

    // Search people (artists, actors, etc.) by name
    static func searchArtistURL(name: String) -> String {
        return "\(baseURL)/search/people?q=\(name)"
    }

    // Get artist details including their cast credits (by artist ID)
    static func getArtistDetailsURL(artistID: Int) -> String {
        return "\(baseURL)/people/\(artistID)?embed=castcredits"
    }
}
