//
//  GetListCacheSongUseCaseMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

@testable import BLMusic

final class GetListCacheSongUseCaseMock: GetListCacheSongUseCase, Mockable {
    
    let songRepository: SongRepository
    
    init(songRepository: SongRepository) {
        self.songRepository = songRepository
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case getListCacheSong(Result<[Song], Error>)
        
        enum Case {
            case getListCacheSong
        }
        
        var `case`: Case {
            switch self {
            case .getListCacheSong: return .getListCacheSong
            }
        }
    }
            
    func getListCacheSong(completion: @escaping (Result<[Song], Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .getListCacheSong }) else {
            return
        }
        
        switch mock {
        case .getListCacheSong(let result):
            switch result {
            case .success(let songs):
                completion(.success(songs))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
