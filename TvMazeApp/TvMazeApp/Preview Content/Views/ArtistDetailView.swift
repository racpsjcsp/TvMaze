//
//  ArtistDetailView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct ArtistDetailView: View {
    let artist: Artist
    
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
                
                // TV Shows
                if !artist.shows.isEmpty {
                    Text("TV Shows")
                        .font(.headline)
                        .padding(.top)
                    
                    ForEach(artist.shows) { show in
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
                        }
                        .padding(.vertical, 4)
                    }
                } else {
                    Text("No TV shows available.")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .padding()
        }
        .navigationTitle(artist.name)
    }
}

#Preview {
//    ArtistDetailView()
}
