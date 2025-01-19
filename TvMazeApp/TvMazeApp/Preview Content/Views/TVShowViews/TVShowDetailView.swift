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
                    Text("\(StringUtils.airingScheduleLabel) \(schedule)")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                // Genres
                if let genres = show.genresText {
                    Text("\(StringUtils.genresLabel) \(genres)")
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
                    Section(header: Text("\(StringUtils.season) \(season)")
                        .font(.headline)
                        .padding(.top)) {
                            ForEach(viewModel.episodesBySeason[season] ?? []) { episode in
                                NavigationLink(destination: EpisodeDetailView(episode: episode)) {
                                    VStack(alignment: .leading) {
                                        Text("S\(episode.season)E\(episode.number): \(episode.name)")
                                            .font(.subheadline)

                                        // Airdate handling moved to a computed property
                                        Text(getFormattedAirdate(for: episode))
                                            .font(.caption)
                                            .foregroundColor(.secondary)
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

    private func getFormattedAirdate(for episode: Episode) -> String {
        if let airdate = episode.airdate,
           let formattedDate = DateUtils.formatDate(airdate) {
            return "\(StringUtils.episodeAirDateLabel) \(formattedDate)"
        } else {
            return "\(StringUtils.episodeAirDateLabel) \(StringUtils.notAvailable)"
        }
    }
}
