//
//  TVShowViewModel.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation
import Combine

class TVShowViewModel: ObservableObject {
    @Published var shows: [TVShow] = []
    @Published var isLoading = false
    @Published var searchQuery: String = ""

    private var currentPage = 0
    private var cancellables = Set<AnyCancellable>()

    func fetchShows() {
        guard !isLoading else { return }
        isLoading = true
        let urlString = "https://api.tvmaze.com/shows?page=\(currentPage)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TVShow].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching shows: \(error.localizedDescription)")
                }
            }, receiveValue: { shows in
                self.shows.append(contentsOf: shows)
                self.currentPage += 1
            })
            .store(in: &cancellables)
    }

    func searchShows(query: String) {
        guard !query.isEmpty else {
            shows = []  // Clear search results if query is empty
            currentPage = 0
            fetchShows()
            return
        }

        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.tvmaze.com/search/shows?q=\(searchQuery)"
        guard let url = URL(string: urlString) else { return }

        isLoading = true

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [SearchResult].self, decoder: JSONDecoder())
            .map { $0.map { $0.show } }  // Extract TVShow from SearchResult
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error searching shows: \(error.localizedDescription)")
                }
            }, receiveValue: { [weak self] shows in
                self?.shows = shows
            })
            .store(in: &cancellables)
    }
}
