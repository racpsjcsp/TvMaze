//
//  EpisodeDetailView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct EpisodeDetailView: View {
    let episode: Episode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Episode Image
                if let imageUrl = episode.image?.original, let url = URL(string: imageUrl) {
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

                // Episode Name
                Text(episode.name)
                    .font(.title)
                    .bold()

                // Season and Episode Number
                Text("\(StringUtils.season) \(episode.season), \(StringUtils.episode) \(episode.number)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                // Summary
                if let summary = episode.cleanedSummary {
                    Text(summary)
                        .font(.body)
                } else {
                    Text(StringUtils.noSummaryAvailable)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
        .navigationTitle(episode.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    //    EpisodeDetailView()
}
