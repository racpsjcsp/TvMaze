//
//  ArtistSearchView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct ArtistSearchView: View {
    @StateObject private var viewModel = ArtistViewModel()
    @State private var searchQuery: String = ""
    
    var body: some View {
        VStack {
            HStack {
                // Search Field
                TextField("Search for an artist...", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.leading)
                    .onSubmit {
                        viewModel.searchArtist(by: searchQuery)  // 🔎 Trigger search on Return key
                    }
                
                // Search Button
                Button(action: {
                    viewModel.searchArtist(by: searchQuery)  // 🔎 Trigger search on button tap
                }) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .clipShape(Circle())
                }
                .padding(.trailing)
            }
            .padding(.top)
            
            // Search Results
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if viewModel.artists.isEmpty && !searchQuery.isEmpty {
                Text(StringUtils.noResultsFound)
                    .foregroundColor(.secondary)
                    .padding()
            } else {
                List(viewModel.artists) { artist in
                    NavigationLink(destination: ArtistDetailView(artist: artist)) {
                        HStack {
                            // Artist Image
                            AsyncImage(url: URL(string: artist.imageURL ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                            }
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            
                            // Artist Name
                            Text(artist.name)
                                .font(.headline)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(StringUtils.artistSearchTitle)
    }
}

#Preview {
    ArtistSearchView()
}
