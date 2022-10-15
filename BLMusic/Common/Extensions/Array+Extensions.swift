//
//  Array+Extensions.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

extension Array where Element == Song {
    
    mutating func update(_ newState: Song.State = .onCloud, url: URL? = nil, at index: Int) {
        if url == nil {
            self[index].change(newState, url: self[index].cacheURL)
            return
        }
        self[index].change(newState, url: url)
    }

}

