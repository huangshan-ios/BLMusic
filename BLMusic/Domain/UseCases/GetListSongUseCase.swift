//
//  GetListSongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol GetListSongUseCase {
    func getListSong(
        baseOn cacheSongs: [Song],
        completion: @escaping (Result<[Song], Error>) -> Void
    ) -> Cancellable?
}

final class GetListSongUseCaseImpl: GetListSongUseCase {
    private let songRepository: SongRepository
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    func getListSong(
        baseOn cacheSongs: [Song],
        completion: @escaping (Result<[Song], Error>) -> Void
    ) -> Cancellable? {
        return songRepository.getListSong { result in
            switch result {
            case .success(let songs):
                var newSongs = songs.map({ SongMapper.map($0) })
                for cacheSong in cacheSongs {
                    if let indexSongDTO = songs.firstIndex(where: { $0.id == cacheSong.id }) {
                        let newSong = SongMapper.nestedMap(songs[indexSongDTO])(cacheSong)
                        newSongs.remove(at: indexSongDTO)
                        newSongs.insert(newSong, at: indexSongDTO)
                    }
                }
                completion(.success(newSongs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
