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

    func fetchEpisodes(for showID: Int) {
        isLoading = true
        let urlString = "https://api.tvmaze.com/shows/\(showID)/episodes"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .map { episodes in
                Dictionary(grouping: episodes, by: { $0.season })
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching episodes: \(error.localizedDescription)")
                }
            }, receiveValue: { groupedEpisodes in
                self.episodesBySeason = groupedEpisodes
            })
            .store(in: &cancellables)
    }
}
