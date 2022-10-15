//
//  Song.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

struct Song {
    enum State {
        case notDownloaded
        case downloading(Double)
        case downloaded
        case playing
        case notPlaying
    }
    
    let id: String
    let name: String
    let url: String
    
    var state: State = .notDownloaded
    var cacheURL: URL?
    
    mutating func change(_ newState: State = .notDownloaded, url: URL? = nil) {
        self.state = newState
        self.cacheURL = url
    }
    
}
