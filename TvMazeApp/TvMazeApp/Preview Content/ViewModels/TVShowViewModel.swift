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

    private let service = TVMazeService.shared

    func fetchShows() {
        guard !isLoading else { return }
        isLoading = true

        service.fetchShows(page: currentPage) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let shows):
                    self?.shows.append(contentsOf: shows)
                    self?.currentPage += 1
                case .failure(let error):
                    print("Error fetching shows: \(error.localizedDescription)")
                }
            }
        }
    }

    func searchShows(query: String) {
        guard !query.isEmpty else {
            shows = []  // Clear search results if query is empty
            currentPage = 0
            fetchShows()
            return
        }

        isLoading = true

        service.searchShows(query: query) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let shows):
                    self?.shows = shows
                case .failure(let error):
                    print("Error searching shows: \(error.localizedDescription)")
                }
            }
        }
    }
}
