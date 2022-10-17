//
//  Song.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

struct Song {
    enum State {
        case onCloud
        case downloading(Double)
        case ready
        case playing
        
        var isOnCloud: Bool {
            guard case .onCloud = self else {
                return false
            }
            return true
        }
        
        var isReady: Bool {
            guard case .ready = self else {
                return false
            }
            return true
        }
    }
    
    let id: String
    let name: String
    let url: String
    
    var state: State = .onCloud
    var cacheURL: URL?
    
    mutating func change(_ newState: State = .onCloud, url: URL? = nil) {
        self.state = newState
        self.cacheURL = url
    }
    
}
