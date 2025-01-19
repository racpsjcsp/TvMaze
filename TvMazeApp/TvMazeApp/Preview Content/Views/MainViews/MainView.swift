//
//  MainView.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 18/01/25.
//

import SwiftUI

struct MainView: View {
    @StateObject private var authentication = AuthenticationManager.shared

    var body: some View {
        VStack {
            if authentication.isAuthenticated {
                NavigationView {
                    VStack(spacing: 40) {
                        // TV Shows Button
                        CategoryButton(
                            destination: TVShowListView(),
                            title: StringUtils.tvShowTitle,
                            backgroundColor: .blue,
                            textColor: .white
                        )

                        // Artists Button
                        CategoryButton(
                            destination: ArtistSearchView(),
                            title: StringUtils.artists,
                            backgroundColor: .green,
                            textColor: .white
                        )
                    }
                    .navigationTitle(StringUtils.appTitle)
                }
            } else {
                VStack(spacing: 40) {
                    FaceIDTitle()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.black)
                .onAppear {
                    Task {
                        await authentication.authenticateWithFaceID()
                    }
                }
            }
        }.alert(isPresented: $authentication.showAlert) {
            Alert(
                title: Text(StringUtils.errorAuthentication),
                message: Text(authentication.errorDescription ?? StringUtils.errorUnknown),
                dismissButton: .default(Text(StringUtils.okText))
            )
        }
    }
}

#Preview {
    MainView()
}
