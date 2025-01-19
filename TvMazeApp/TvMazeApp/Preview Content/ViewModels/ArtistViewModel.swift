//
//  ArtistViewModel.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation
import Combine

class ArtistViewModel: ObservableObject {
    @Published var artists: [Artist] = []
    @Published var isLoading = false
    @Published var errorMessage: String? = nil

    private var cancellables = Set<AnyCancellable>()
    private let service = TVMazeService.shared

    func searchArtist(by name: String) {
        isLoading = true

        service.searchArtist(by: name) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let artists):
                    self?.artists = artists
                case .failure(let error):
                    self?.errorMessage = "\(StringUtils.errorFetchingArtist) \(error.localizedDescription)"
                    print("\(StringUtils.errorFetchingShowsForArtist) \(error.localizedDescription)")
                }
            }
        }
    }
}
