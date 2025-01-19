//
//  ArtistDetailViewModel.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import Foundation
import Combine

class ArtistDetailViewModel: ObservableObject {
    @Published var shows: [TVShow] = []
    @Published var isLoading = false

    private let service = TVMazeService.shared
    private var cancellables = Set<AnyCancellable>()

    func fetchShowsForArtist(artistID: Int) {
        isLoading = true
        service.fetchShowsForArtist(artistID: artistID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let shows):
                    self?.shows = shows
                case .failure(let error):
                    print("Error fetching shows for artist: \(error.localizedDescription)")
                }
            }
        }
    }
}
