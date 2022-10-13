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
        case downloading(Int)
        case downloaded
        case playing
        case notPlaying
    }
    
    let id: String
    let name: String
    let url: String
    var state: State = .notDownloaded
}
