//
//  SongsStorageMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import Foundation

@testable import BLMusic

final class SongsStorageMock: SongsStorage, Mockable {
    var listMock: [MockType] = []
    
    enum MockType {
        case getListSongEntity(Result<[SongEntity], Error>)
        case save(Result<Void, Error>)
        
        enum Case {
            case getListSongEntity
            case save
        }
        
        var `case`: Case {
            switch self {
            case .getListSongEntity: return .getListSongEntity
            case .save: return .save
            }
        }
    }
    
    func getListSongEntity(completion: @escaping (Result<[SongEntity], Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .getListSongEntity }) else {
            return
        }
        
        switch mock {
        case .getListSongEntity(let result):
            switch result {
            case .success(let entities):
                completion(.success(entities))
            case .failure(let error):
                completion(.failure(error))
            }
        default:
            break
        }
    }
    
    func save(_ dto: SongDTO, cacheURL: URL?, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .save }) else {
            return
        }
        
        switch mock {
        case .save(let result):
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        default:
            break
        }
    }
}
