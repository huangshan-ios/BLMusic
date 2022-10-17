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
        case mock
        
        enum Case {
            case mock
        }
        
        var `case`: Case {
            switch self {
            case .mock: return .mock
            }
        }
    }
    
    func getListLocalSong(completion: @escaping (Result<[SongEntity], Error>) -> Void) {
    }
    
    func getListSong(completion: @escaping (Result<[SongDTO], Error>) -> Void) -> Cancellable? {
        return nil
    }
    
    func downloadSong(_ song: SongDTO, progressHandler: @escaping (Double) -> Void, completionHandler: @escaping (Result<URL, Error>) -> Void) -> Cancellable? {
        return nil
    }
    
    func saveSongToPersistentStorage(_ song: SongDTO, audioCacheURL: URL, completion: @escaping (Result<Void, Error>) -> Void) {
    }
}
