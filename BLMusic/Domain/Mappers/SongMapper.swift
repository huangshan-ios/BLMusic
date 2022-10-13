//
//  SongMapper.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

final class SongMapper {
    class func map(_ dto: SongDTO) -> Song {
        return Song(id: dto.id, name: dto.name, url: dto.url)
    }
}
