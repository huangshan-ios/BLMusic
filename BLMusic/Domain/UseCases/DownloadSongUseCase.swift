//
//  DownloadSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol DownloadSongUseCase {
    var songRepository: SongRepository { get }
    var fileManagerService: FileManagerService { get }
    
    func downloadSong(
        _ song: Song,
        progressHander: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
}

final class DownloadSongUseCaseImpl: DownloadSongUseCase {
    
    let songRepository: SongRepository
    let fileManagerService: FileManagerService
    
    init(songRepository: SongRepository, fileManagerService: FileManagerService) {
        self.songRepository = songRepository
        self.fileManagerService = fileManagerService
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
                    let fileName = song.name.replacingOccurrences(of: " ", with: "_").appending(".mp3")
                    self.saveCache(of: fileName, in: tmpURL, completion: completionHandler)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            })
    }
    
    private func saveCache(
        of fileName: String,
        in tmpURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let cacheDirectory = AppConstants.Document.cacheDirectoryURL
        fileManagerService.createDirectoryIfNeeded(cacheDirectory, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                let cacheURL = cacheDirectory.appendingPathComponent(fileName)
                self.fileManagerService.moveFile(from: tmpURL, to: cacheURL, removedIfDupplicate: true, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
