//
//  DownloadSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol DownloadSongUseCase {
    var songRepository: SongRepository { get }
    var fileRepository: FileRepository { get }
    
    func downloadSong(
        _ song: Song,
        progressHander: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
}

final class DownloadSongUseCaseImpl: DownloadSongUseCase {
    
    let songRepository: SongRepository
    let fileRepository: FileRepository
    
    init(
        songRepository: SongRepository,
        fileRepository: FileRepository
    ) {
        self.songRepository = songRepository
        self.fileRepository = fileRepository
    }
    
    func downloadSong(
        _ song: Song,
        progressHander: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable? {
        return songRepository.downloadSong(
            from: song.url,
            progressHandler: progressHander,
            completionHandler: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case.success(let tmpURL):
                    self.saveCache(of: song.name.replacingOccurrences(of: " ", with: "").appending(".mp3"),
                                   tmpURL: tmpURL, completion: completionHandler)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            })
    }
    
    private func saveCache(of fileName: String, tmpURL: URL, completion: @escaping (Result<URL, Error>) -> Void) {
        fileRepository.saveCache(of: fileName, from: tmpURL, completion: { result in
            switch result {
            case .success(let cacheURL):
                completion(.success(cacheURL))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
