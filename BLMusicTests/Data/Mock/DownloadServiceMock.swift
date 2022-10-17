//
//  DownloadServiceMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import Foundation

@testable import BLMusic

final class DownloadServiceMock: DownloadFileService, Mockable {
    var listMock: [MockType] = []
    
    enum MockType {
        case downloadFile(Result<URL, Error>)
        
        enum Case {
            case downloadFile
        }
        
        var `case`: Case {
            switch self {
            case .downloadFile: return .downloadFile
            }
        }
    }
    
    func downloadFile(
        fileName: String,
        from url: String,
        to directory: URL,
        removeIfDupplicate: Bool,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> DownloadCancellable? {
        guard let mock = listMock.first(where: { $0.case == .downloadFile }) else {
            return nil
        }
        
        switch mock {
        case .downloadFile(let result):
            switch result {
            case .success(let url):
                progressHandler(1)
                completionHandler(.success(url))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
        
        return nil
    }
}
