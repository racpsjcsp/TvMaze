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

    private var cancellables = Set<AnyCancellable>()

    func searchArtist(by name: String) {
        guard !name.isEmpty else { return }
        let urlString = "https://api.tvmaze.com/search/people?q=\(name)"
        guard let url = URL(string: urlString) else { return }

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [ArtistSearchResult].self, decoder: JSONDecoder())
            .map { results in
                results.map { result in
                    Artist(
                        id: result.person.id,
                        name: result.person.name,
                        image: result.person.image,
                        shows: result.embedded?.shows ?? []
                    )
                }
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching artists: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] artists in
                self?.artists = artists
            })
            .store(in: &cancellables)
    }
}
