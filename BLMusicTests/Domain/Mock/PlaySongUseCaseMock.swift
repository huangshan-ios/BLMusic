//
//  PlaySongUseCaseMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

@testable import BLMusic

final class PlaySongUseCaseMock: PlaySongUseCase, Mockable {
    
    let audioService: AudioService
    
    init(audioService: AudioService) {
        self.audioService = audioService
    }
    
    var listMock: [MockType] = []
    
    enum MockType {
        case play(Result<Bool, Error>)
        case stop(Result<Bool, Never>)
        
        enum Case {
            case play
            case stop
        }
        
        var `case`: Case {
            switch self {
            case .play: return .play
            case .stop: return .stop
            }
        }
    }
    
    func play(song: Song, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .play }) else {
            return
        }
        
        switch mock {
        case .play(let result):
            switch result {
            case .success(let isPlaying):
                completion(.success(isPlaying))
            case .failure(let error):
                completion(.failure(error))
            }
        default:
            break
        }
    }
    
    func stopPlaying(completion: @escaping (Result<Bool, Never>) -> Void) {
        guard let mock = listMock.first(where: { $0.case == .stop }) else {
            return
        }
        
        switch mock {
        case .stop(let result):
            switch result {
            case .success(let isStop):
                completion(.success(isStop))
            }
        default:
            break
        }
    }
}
