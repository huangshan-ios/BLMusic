//
//  GetListSongUseCaseMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

import Foundation

@testable import BLMusic

final class GetListSongUseCaseMock: GetListSongUseCase, Mockable {
    
    let songRepository: SongRepository
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case getListSong(Result<[Song], Error>)
        
        enum Case {
            case getListSong
        }
        
        var `case`: Case {
            switch self {
            case .getListSong: return .getListSong
            }
        }
    }
    
    func getListSong(baseOn cacheSongs: [Song], completion: @escaping (Result<[Song], Error>) -> Void) -> Cancellable? {
        guard let mock = listMock.first(where: { $0.case == .getListSong }) else {
            return nil
        }
        
        switch mock {
        case .getListSong(let result):
            switch result {
            case .success(let songs):
                var newSongs = songs
                if !cacheSongs.isEmpty {
                    for cacheSong in cacheSongs {
                        if let indexSongDTO = songs.firstIndex(where: { $0.id == cacheSong.id }) {
                            newSongs.remove(at: indexSongDTO)
                            newSongs.insert(cacheSong, at: indexSongDTO)
                        }
                    }
                }
                completion(.success(newSongs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return nil
    }
}
