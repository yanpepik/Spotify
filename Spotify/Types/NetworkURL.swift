//
//  NetworkURL.swift
//  Spotify
//
//  Created by Yan Pepik on 06/02/2023.
//

import Foundation

enum NetworkURL {
  case getArtistsAlbums(artistID: String)
}

extension NetworkURL {
  var url: URL? {
    switch self {
    case .getArtistsAlbums(let artistID):
      let baseURL = NetworkURL.baseURL?.absoluteString ?? ""
      return URL(string: baseURL + URLPaths.path.getArtistsAlbumsTypes + "/\(artistID)" + URLPaths.content.getArtistsAlbumsTypes)
    }
  }

  static var baseURL: URL? {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.spotify.com"
    components.path = "/v1"
    guard let url = components.url else { return nil }
    return url
  }
}
