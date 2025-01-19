//
//  StringUtils.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import Foundation

struct StringUtils {

    // MARK: - General Strings
    static let appTitle = "TVMaze App"
    static let searchPlaceholder = "Search for an artist..."
    static let noResultsFound = "No results found."
    static let loadingText = "Loading..."
    static let loadingShowsText = "Loading shows..."

    // MARK: - Artist Strings
    static let artistSearchTitle = "Search Artists"
    static let artistNameLabel = "Artist Name"
    static let noShowsAvailable = "No TV shows available."
    static let artists = "Artists"

    // MARK: - TV Show Strings
    static let tvShowTitle = "TV Shows"
    static let tvShowSearchPlaceholder = "Search TV Shows..."
    static let tvShowDetailTitle = "TV Show Details"
    static let airDateLabel = "Air Date: "
    static let genresLabel = "Genres: "
    static let airingScheduleLabel = "Airs: "
    static let noSummaryAvailable = "No summary available."
    static let tvMazeSeries = "TVMaze Series"
    static let search = "Search"


    // MARK: - Episode Strings
    static let episodeDetailsTitle = "Episode Details"
    static let seasonEpisodeFormat = "S%dE%d: %@"
    static let episodeAirDateLabel = "Air Date: "
    static let season = "Season"
    static let episode = "Episode"


    // MARK: - Error Strings
    static let errorFetchingData = "Error fetching data. Please try again."
    static let errorFetchingShowsForArtist = "Error fetching shows for artist:"
    static let errorFetchingArtist = "Error fetching artists:"
    static let errorFetchingEpisode = "Error fetching episodes:"
    static let errorFetchingShows = "Error searching shows:"
}

