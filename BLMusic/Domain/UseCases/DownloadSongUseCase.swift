//
//  DownloadSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol DownloadSongUseCase {
    func downloadSong(
        with url: String,
        completion: @escaping (Song.State) -> Void
    )
    
}

final class DownloadSongUseCaseImpl: DownloadSongUseCase {
    func downloadSong(
        with url: String,
        completion: @escaping (Song.State) -> Void
    ) {
        
    }
}
