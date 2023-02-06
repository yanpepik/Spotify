//
//  AccessToken.swift
//  Spotify
//
//  Created by Yan Pepik on 06/02/2023.
//

import Foundation

struct AccessToken: Decodable {
    let token: String?
    let type: String?
    let expire: Int?

    enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case expire = "expires_in"
    }
}
