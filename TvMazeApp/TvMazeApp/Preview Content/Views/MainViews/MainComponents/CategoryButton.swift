//
//  CategoryButton.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import SwiftUI

struct CategoryButton<Destination: View>: View {
    var destination: Destination
    var title: String
    var backgroundColor: Color
    var textColor: Color

    var body: some View {
        NavigationLink(destination: destination) {
            Text(title)
                .font(.title2)
                .bold()
                .padding()
                .frame(maxWidth: .infinity)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .cornerRadius(10)
                .padding(.horizontal, 40)
        }
    }
}
