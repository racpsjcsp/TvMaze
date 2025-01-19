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
        let urlString = APIEndpoints.getShowsURL(page: page)
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
        let urlString = APIEndpoints.searchShowsURL(query: searchQuery)
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
    func fetchEpisodes(for showID: Int, completion: @escaping (Result<[Int: [Episode]], Error>) -> Void) {
        let urlString = APIEndpoints.getEpisodesURL(for: showID)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Episode].self, decoder: JSONDecoder())
            .map { episodes in
                Dictionary(grouping: episodes, by: { $0.season })
            }
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { groupedEpisodes in
                completion(.success(groupedEpisodes))
            })
            .store(in: &cancellables)
    }

    func searchArtist(by name: String, completion: @escaping (Result<[Artist], Error>) -> Void) {
        guard !name.isEmpty else {
            completion(.success([])) // Return empty array if name is empty
            return
        }

        let urlString = APIEndpoints.searchArtistURL(name: name)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }

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
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { artists in
                completion(.success(artists))
            })
            .store(in: &cancellables)
    }

    func fetchArtistDetails(artistID: Int, completion: @escaping (Result<[TVShow], Error>) -> Void) {
        let urlString = APIEndpoints.getArtistDetailsURL(artistID: artistID)
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else { return }
            print(String(data: data, encoding: .utf8) ?? "No data")
        }.resume()

        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: ArtistDetailsResponse.self, decoder: JSONDecoder())
            .map { response in
                
                response.embedded.castCredits.compactMap { $0.show } // Extract show names
            }
            .sink(receiveCompletion: { completionStatus in
                if case .failure(let error) = completionStatus {
                    completion(.failure(error))
                }
            }, receiveValue: { showNames in
                print(showNames)
                completion(.success(showNames))
            })
            .store(in: &cancellables)
    }
}
