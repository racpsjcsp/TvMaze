//
//  ArtistDetailView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist
    @StateObject private var viewModel = ArtistDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Artist Image
                if let imageUrl = artist.imageURL, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: 300)
                    .cornerRadius(10)
                }
                
                // Artist Name
                Text(artist.name)
                    .font(.title)
                    .bold()
                
                // List of shows
                if viewModel.isLoading {
                    ProgressView(StringUtils.loadingShowsText)
                } else {
                    if !viewModel.shows.isEmpty {
                        Text(StringUtils.tvShowTitle)
                            .font(.headline)
                            .padding(.top)

                        List(viewModel.shows, id: \.self) { show in
                            NavigationLink(destination: TVShowDetailView(show: show)) {
                                HStack {
                                    AsyncImage(url: URL(string: show.image?.medium ?? "")) { image in
                                        image
                                            .resizable()
                                            .scaledToFit()
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .frame(width: 60, height: 90)
                                    .cornerRadius(8)

                                    Text(show.name)
                                        .font(.subheadline)
                                }
                                Text(show.name)
                            }
                        }
                    } else {
                        Text(StringUtils.noShowsAvailable)
                            .foregroundColor(.secondary)
                            .padding()
                    }
                }
            }
            .padding()
        }
        .navigationTitle(artist.name)
        .onAppear {
            viewModel.fetchShowsForArtist(artistID: artist.id)
        }
    }
}

#Preview {
//    ArtistDetailView()
}
