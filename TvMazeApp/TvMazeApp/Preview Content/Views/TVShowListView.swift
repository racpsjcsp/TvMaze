//
//  TVShowListView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct TVShowListView: View {
    @StateObject private var viewModel = TVShowViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.shows) { show in
                    TVShowCardView(show: show)
                        .onAppear {
                            if show == viewModel.shows.last  && viewModel.searchQuery.isEmpty {
                                viewModel.fetchShows()
                            }
                        }
                }

                if viewModel.isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .searchable(text: $viewModel.searchQuery, prompt: "Search")
            .onChange(of: viewModel.searchQuery) { _, newValue in
                viewModel.searchShows(query: newValue)
            }
            .navigationTitle("TVMaze Series")
            .onAppear {
                viewModel.fetchShows()
            }
        }
    }
}

#Preview {
    TVShowListView()
}
