//
//  TVShowDetailView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct TVShowDetailView: View {
    let show: TVShow
    @StateObject private var viewModel = TVShowDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Poster
                AsyncImage(url: URL(string: show.image?.original ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: 300)
                .cornerRadius(10)
                
                // Name
                Text(show.name)
                    .font(.title)
                    .bold()
                
                // Airing Days & Time
                if let schedule = show.scheduleText {
                    Text("Airs: \(schedule)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Genres
                if let genres = show.genresText {
                    Text("Genres: \(genres)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Summary
                if let summary = show.cleanedSummary {
                    Text(summary)
                        .font(.body)
                }
                
                // Episodes by Season
                ForEach(viewModel.episodesBySeason.keys.sorted(), id: \.self) { season in
                    Section(header: Text("Season \(season)")
                        .font(.headline)
                        .padding(.top)) {
                            ForEach(viewModel.episodesBySeason[season] ?? []) { episode in
                                NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                                    VStack(alignment: .leading) {
                                        Text("S\(episode.season)E\(episode.number): \(episode.name)")
                                            .font(.subheadline)
                                        if let airdate = episode.airdate {
                                            Text("Air Date: \(airdate)")
                                                .font(.caption)
                                                .foregroundColor(.secondary)
                                        }
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                        }
                }
            }
            .padding()
        }
        .navigationTitle(show.name)
        .onAppear {
            viewModel.fetchEpisodes(for: show.id)
        }
    }
}

#Preview {
    //    TVShowDetailView()
}
