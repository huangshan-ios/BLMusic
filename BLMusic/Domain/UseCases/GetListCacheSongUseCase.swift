//
//  GetListCacheSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

protocol GetListCacheSongUseCase {
    var songRepository: SongRepository { get }
    
    func getListCacheSong(completion: @escaping (Result<[Song], Error>) -> Void)
}

final class GetListCacheSongUseCaseImpl: GetListCacheSongUseCase {
    let songRepository: SongRepository
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    func getListCacheSong(completion: @escaping (Result<[Song], Error>) -> Void) {
        songRepository.getListLocalSong { result in
            switch result {
            case .success(let entities):
                let songs = entities.map({ SongMapper.map($0) })
                completion(.success(songs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
