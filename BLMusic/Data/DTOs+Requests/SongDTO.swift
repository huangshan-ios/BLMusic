//
//  SongDTO.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

struct SongDTO: Codable {
    let id, name, url: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case url = "audioURL"
    }
}
