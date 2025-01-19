//
//  TVMazeService.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import Foundation
import Combine

class TVMazeService: ObservableObject {
    static let shared = TVMazeService()

    private var cancellables = Set<AnyCancellable>()

    private init() {}

    // Fetch shows (no state management here)
    func fetchShows(page: Int, completion: @escaping (Result<[TVShow], Error>) -> Void) {
        let urlString = "https://api.tvmaze.com/shows?page=\(page)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [TVShow].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { shows in
                completion(.success(shows))
            })
            .store(in: &cancellables)
    }

    // Search shows (no state management here)
    func searchShows(query: String, completion: @escaping (Result<[TVShow], Error>) -> Void) {
        guard !query.isEmpty else {
            completion(.success([])) // Return empty array if query is empty
            return
        }

        let searchQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.tvmaze.com/search/shows?q=\(searchQuery)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [SearchResult].self, decoder: JSONDecoder())
            .map { $0.map { $0.show } }  // Extract TVShow from SearchResult
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { shows in
                completion(.success(shows))
            })
            .store(in: &cancellables)
    }

    // Fetch episodes by season (no state management here)
    func fetchEpisodes(for showID: Int, completion: @escaping (Result<[Episode], Error>) -> Void) {
        let urlString = "https://api.tvmaze.com/shows/\(showID)/episodes"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { episodes in
                completion(.success(episodes))
            })
            .store(in: &cancellables)
    }
}
