//
//  AuthManager.swift
//  Spotify
//
//  Created by Yan Pepik on 06/02/2023.
//

import Foundation
import Combine

class AuthManager {

    static let shared = AuthManager()

    private let authKey: String = {
        let clientID = "29506c44f71a49ef8d46d8a86ddb04b3"
        let clientSecret = "661ec4ce4e754e738c8f79b0549824ef"
        let rawKey = "\(clientID):\(clientSecret)"
        let encodedKey = rawKey.data(using: .utf8)?.base64EncodedString() ?? ""
        return "Basic \(encodedKey)"
    }()

    private init() {}
}

struct APIAuthentication {
  private var baseURL = "https://accounts.spotify.com/"
  private var path = "authorize"

  // SCOPE = Check available scopes on  https://developer.spotify.com/documentation/general/guides/scopes/
  // CLIENT_ID = Get yours on https://developer.spotify.com/dashboard/applications
  // REDIRECT_URI = A random website to redirect(we'll cut the connection before loading this site into the user screen)
  // IMPORTANT: 'REDIRECT_URI' should be exactly equal to what you typed on your api project on spotify developer website.

  func getAuthURL(clientID: String,
                  scope: String,
                  redirectURI: String) -> String {

    var url = baseURL
    url += "\(path)?"

    url += "client_id=\(clientID)"
    url += "&redirect_uri=\(redirectURI)"
    url += "&scope=\(scope)"
    url += "&response_type=code"

    return url
  }

  func getAccessKey(
    code: String,
    redirectURI: String,
    clientID: String,
    clientSecret: String,
    completionHandler: @escaping (AuthKey) -> Void
  ) {
    let baseUrl = "https://accounts.spotify.com/api/token"

    let headers: HTTPHeaders = ["Content-Type": "application/x-www-form-urlencoded"]

    let parameters = [
      "grant_type": "authorization_code",
      "code": code,
      "redirect_uri": redirectURI,
      "client_id": clientID,
      "client_secret": clientSecret
    ]

    let encoder = URLEncodedFormParameterEncoder(encoder: URLEncodedFormEncoder(spaceEncoding: .percentEscaped))

    AF.request(baseUrl,
               method: .post,
               parameters: parameters,
               encoder: encoder,
               headers: headers)
      .responseDecodable(of: AuthKey.self) { response in
        guard let key = response.value else {
          fatalError("""
                     Error receiving access keys from API. Check if your ApiKey/Secret are correct in YourSensitiveData.
                     If you tried to log in using Google, Apple or Facebook, this may be the error cause
                     (in some cases this type of authentication is resulting in errors)
                     """
          )
        }
        completionHandler(key)
      }
  }
}
