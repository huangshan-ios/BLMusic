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
        case downloaded(URL)
        case playing
        case notPlaying
        
        var isDownloaded: Bool {
            guard case .downloaded = self else {
                return false
            }
            return true
        }
    }
    
    let id: String
    let name: String
    let url: String
    var state: State = .notDownloaded
}
