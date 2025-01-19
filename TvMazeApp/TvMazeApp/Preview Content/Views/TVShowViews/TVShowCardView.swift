//
//  TVShowCardView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct TVShowCardView: View {
    let show: TVShow

    var body: some View {
        NavigationLink(destination: TVShowDetailView(show: show)) {
            HStack {
                AsyncImage(url: URL(string: show.image?.medium ?? "")) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 80, height: 120)
                .cornerRadius(8)
                
                VStack(alignment: .leading) {
                    Text(show.name)
                        .font(.headline)
                    if let summary = show.cleanedSummary {
                        Text(summary.prefix(100) + "...")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}
