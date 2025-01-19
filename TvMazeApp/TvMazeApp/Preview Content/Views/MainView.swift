//
//  MainView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 40) {
                // TV Shows Button
                NavigationLink(destination: TVShowListView()) {
                    Text("TV Shows")
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
                
                // Artists Button
                NavigationLink(destination: ArtistSearchView()) {
                    Text("Artists")
                        .font(.title2)
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal, 40)
                }
            }
            .navigationTitle("TVMaze App")
        }
    }
}

#Preview {
    MainView()
}
