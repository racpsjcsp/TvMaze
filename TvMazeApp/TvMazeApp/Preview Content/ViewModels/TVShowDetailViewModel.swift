//
//  TVShowDetailViewModel.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation
import Combine

class TVShowDetailViewModel: ObservableObject {
    @Published var episodesBySeason: [Int: [Episode]] = [:]
    @Published var isLoading = false

    private var cancellables = Set<AnyCancellable>()

    private let service = TVMazeService.shared

    func fetchEpisodes(for showID: Int) {
        isLoading = true

        service.fetchEpisodes(for: showID) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let groupedEpisodes):
                    self?.episodesBySeason = groupedEpisodes
                case .failure(let error):
                    print("\(StringUtils.errorFetchingEpisode) \(error.localizedDescription)")
                }
            }
        }
    }
}
