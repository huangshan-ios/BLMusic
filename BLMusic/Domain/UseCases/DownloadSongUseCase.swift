//
//  DownloadSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol DownloadSongUseCase {
    var songRepository: SongRepository { get }
    
    func downloadSong(
        _ song: Song,
        progressHander: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
}

final class DownloadSongUseCaseImpl: DownloadSongUseCase {
    let songRepository: SongRepository
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    func downloadSong(
        _ song: Song,
        progressHander: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable? {
        return songRepository.downloadSong(song, progressHandler: progressHander, completionHandler: completionHandler)
    }
}
