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
        let songDTO = SongMapper.map(song)
        return songRepository.downloadSong(
            songDTO,
            progressHandler: progressHander,
            completionHandler: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let audioCacheURL):
                    self.saveSongToPersistentStorage(
                        songDTO,
                        audioCacheURL: audioCacheURL,
                        completion: completionHandler
                    )
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        )
    }
}

// MARK: Private functions
extension DownloadSongUseCaseImpl {
    private func saveSongToPersistentStorage(
        _ songDTO: SongDTO,
        audioCacheURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        songRepository.saveSongToPersistentStorage(
            songDTO,
            audioCacheURL: audioCacheURL,
            completion: { result in
                switch result {
                case .success:
                    completion(.success(audioCacheURL))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}
