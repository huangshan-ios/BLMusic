//
//  Song.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

struct Song {
    enum State {
        case inCloud
        case downloading(Double)
        case ready
        case playing
    }
    
    let id: String
    let name: String
    let url: String
    
    var state: State = .inCloud
    var cacheURL: URL?
    
    mutating func change(_ newState: State = .inCloud, url: URL? = nil) {
        self.state = newState
        self.cacheURL = url
    }
    
}
