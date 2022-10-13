//
//  GetListSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol GetListSongUseCase {
    var  songRepository: SongRepository { get }
    
    func getListSong(completion: @escaping (Result<[Song], Error>) -> Void) -> Cancellable?
}

final class GetListSongUseCaseImpl: GetListSongUseCase {
    let songRepository: SongRepository
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    func getListSong(completion: @escaping (Result<[Song], Error>) -> Void) -> Cancellable? {
        return songRepository.getListSong { result in
            switch result {
            case .success(let songs):
                let songs = songs.map({ SongMapper.map($0) })
                completion(.success(songs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
