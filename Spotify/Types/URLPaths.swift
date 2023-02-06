//
//  URLPaths.swift
//  Spotify
//
//  Created by Yan Pepik on 06/02/2023.
//

import Foundation

enum URLPaths {
  case path
  case content
}

extension URLPaths {
  var getArtistsAlbumsTypes: String {
    switch self {
    case .path:
      return "/artists"
    case .content:
      return "/albums"
    }
  }
}
