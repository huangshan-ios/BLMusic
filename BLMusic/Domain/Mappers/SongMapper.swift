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
    
    class func nestedMap(_ dto: SongDTO) -> (Song) -> Song {
        return { cacheSong in
            return Song(id: dto.id, name: dto.name, url: dto.url, state: .ready, cacheURL: cacheSong.cacheURL)
        }
    }
    
    class func map(_ entity: SongEntity) -> Song {
        return Song(id: entity.id ?? "", name: entity.name ?? "",
                    url: entity.url ?? "", state: .ready,
                    cacheURL: entity.cacheURL)
    }
    
    class func map(_ model: Song) -> SongDTO {
        return SongDTO(id: model.id, name: model.name, url: model.url)
    }
}
