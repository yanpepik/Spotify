//
//  SpotifyApp.swift
//  Spotify
//
//  Created by Yan Pepik on 24/01/2023.
//

import SwiftUI
import Combine

@main
struct SpotifyApp: App {
    var body: some Scene {
        WindowGroup {
            AlbumListView(viewModel: AlbumListViewModel())
        }
    }
}
