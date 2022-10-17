//
//  AudioServiceMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import Foundation

@testable import BLMusic

final class AudioServiceMock: AudioService, Mockable {
    
    var listMock: [MockType] = []
    
    enum MockType {
        case playSong(Result<Bool, Error>)
        case stopPlaying(Result<Bool, Never>)
        
        enum Case {
            case playSong
            case stopPlaying
        }
        
        var `case`: Case {
            switch self {
            case .playSong: return .playSong
            case .stopPlaying: return .stopPlaying
            }
        }
    }
    
    func playSong(_ url: URL?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .playSong }) else {
            return
        }
        
        switch mock {
        case .playSong(let result):
            switch result {
            case .success(let isPlaying):
                completion(.success(isPlaying))
            case .failure(let error):
                completion(.failure(error))
            }
        default: break
        }
    }
    
    func stopPlaying(completion: @escaping (Result<Bool, Never>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .stopPlaying }) else {
            return
        }
        
        switch mock {
        case .stopPlaying(let result):
            switch result {
            case .success(let isPlaying):
                completion(.success(isPlaying))
            }
        default: break
        }
    }
}
