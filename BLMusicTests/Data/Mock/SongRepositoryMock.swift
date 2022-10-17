//
//  SongRepositoryMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

@testable import BLMusic

final class SongRepositoryMock: SongRepository, Mockable {
    
    var listMock: [MockType] = []
    
    enum MockType {
        case getListLocalSong(Result<[SongEntity], Error>)
        case getListSong(Result<[SongDTO], Error>)
        case downloadSong(Result<URL, Error>)
        case saveSongToPersistentStorage(Result<Void, Error>)
        
        enum Case {
            case getListLocalSong
            case getListSong
            case downloadSong
            case saveSongToPersistentStorage
        }
        
        var `case`: Case {
            switch self {
            case .getListLocalSong: return .getListLocalSong
            case .getListSong: return .getListSong
            case .downloadSong: return .downloadSong
            case .saveSongToPersistentStorage: return .saveSongToPersistentStorage
            }
        }
    }
    
    func getListLocalSong(completion: @escaping (Result<[SongEntity], Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .getListLocalSong }) else {
            return
        }
        
        switch mock {
        case .getListLocalSong(let result):
            switch result {
            case .success(let entities):
                completion(.success(entities))
            case .failure(let error):
                completion(.failure(error))
            }
        default: break
        }
    }
    
    func getListSong(completion: @escaping (Result<[SongDTO], Error>) -> Void) -> Cancellable? {
        guard let mock = listMock.first(where: { $0.case == .getListSong }) else {
            return nil
        }
        
        switch mock {
        case .getListSong(let result):
            switch result {
            case .success(let songDTOs):
                completion(.success(songDTOs))
            case .failure(let error):
                completion(.failure(error))
            }
        default: break
        }
        return nil
    }
    
    func downloadSong(_ song: SongDTO, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (Result<URL, Error>) -> Void) -> Cancellable? {
        guard let mock = listMock.first(where: { $0.case == .downloadSong }) else {
            return nil
        }
        
        switch mock {
        case .downloadSong(let result):
            switch result {
            case .success(let url):
                progressHandler(1)
                completionHandler(.success(url))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        default: break
        }
        return nil
    }
    
    func saveSongToPersistentStorage(_ song: SongDTO, audioCacheURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .saveSongToPersistentStorage }) else {
            return
        }
        
        switch mock {
        case .saveSongToPersistentStorage(let result):
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        default: break
        }
    }
}
