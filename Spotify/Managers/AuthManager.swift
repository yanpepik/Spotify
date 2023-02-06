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

  // Authentication URL
      private let tokenURL: URL? = {
          var components = URLComponents()
          components.scheme = "https"
          components.host = "accounts.spotify.com"
          components.path = "/api/token"
          return components.url
      }()

    private init() {}

  /// Request method for access token.
    func getAccessToken() -> AnyPublisher<String, Error> {
        // strong token url
        guard let url = tokenURL else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        // url request setups
        var urlRequest = URLRequest(url: url)
        // add authKey to "Authorization" for request headers
        urlRequest.allHTTPHeaderFields = ["Authorization": authKey,
                                          "Content-Type": "application/x-www-form-urlencoded"]
        // add query items for request body
        var requestBody = URLComponents()
        requestBody.queryItems = [URLQueryItem(name: "grant_type", value: "client_credentials")]
        urlRequest.httpBody = requestBody.query?.data(using: .utf8)
        urlRequest.httpMethod = HTTPMethods.post.rawValue
        // return dataTaskPublisher for request
        return URLSession.shared
            .dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                // throw error when bad server response is received
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            // decode the data with AccessToken decodable model
            .decode(type: AccessToken.self, decoder: JSONDecoder())
            // reinforce for decoded data
            .map { accessToken -> String in
                guard let token = accessToken.token else {
                    print("The access token is not fetched.")
                    return ""
                }
                return token
            }
            // main thread transactions
            .receive(on: RunLoop.main)
            // publisher spiral for AnyPublisher<String, Error>
            .eraseToAnyPublisher()
    }
}
