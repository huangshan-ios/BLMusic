//
//  DownloadSongUseCaseMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

@testable import BLMusic

final class DownloadSongUseCaseMock: DownloadSongUseCase, Mockable {
    
    var listMock: [MockType] = []
    
    enum MockType {
        case downloadSong(Result<URL, Error>)
        
        enum Case {
            case downloadSong
        }
        
        var `case`: Case {
            switch self {
            case .downloadSong: return .downloadSong
            }
        }
    }
    
    func downloadSong(
        _ song: Song,
        progressHander: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable? {
        guard let mock = listMock.first(where: { $0.case == .downloadSong }) else {
            return nil
        }
        
        switch mock {
        case .downloadSong(let result):
            switch result {
            case .success(let cacheAudioURL):
                progressHander(1)
                completionHandler(.success(cacheAudioURL))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        return nil
    }
}
