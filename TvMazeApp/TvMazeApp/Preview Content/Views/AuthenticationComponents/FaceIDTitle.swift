//
//  FaceIDTitle.swift
//  TvMazeApp
//
//  Created by Rafael Plinio on 19/01/25.
//

import SwiftUI

struct FaceIDTitle: View {
    var body: some View {
        Text(StringUtils.appTitle)
            .font(.largeTitle)
            .foregroundStyle(.blue)
            .bold()
    }
}

struct FaceIDTitle_Previews: PreviewProvider {
    static var previews: some View {
        FaceIDTitle()
    }
}
