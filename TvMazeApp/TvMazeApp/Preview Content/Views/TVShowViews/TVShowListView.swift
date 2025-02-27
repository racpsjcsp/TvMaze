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
                    ProgressView(StringUtils.loadingText)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .searchable(text: $viewModel.searchQuery, prompt: StringUtils.search)
            .onChange(of: viewModel.searchQuery) { _, newValue in
                viewModel.searchShows(query: newValue)
            }
            .navigationTitle(StringUtils.tvMazeSeries)
            .onAppear {
                viewModel.fetchShows()
            }
            .alert(isPresented: Binding<Bool>(
                get: { viewModel.errorMessage != nil },
                set: { _ in viewModel.errorMessage = nil } // Reset error message when alert is dismissed
            )) {
                Alert(
                    title: Text(StringUtils.errorTitle),
                    message: Text(viewModel.errorMessage ?? StringUtils.errorUnknownOcurred),
                    dismissButton: .default(Text(StringUtils.okText))
                )
            }
        }
    }
}

#Preview {
    TVShowListView()
}
