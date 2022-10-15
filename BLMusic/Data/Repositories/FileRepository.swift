//
//  FileRepository.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

protocol FileRepository {
    var fileStorageSerivce: FileStorageService { get }
    
    func saveCache(
        of fileName: String,
        from tmpURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    )
}

final class FileRepositoryImpl: FileRepository {
    let fileStorageSerivce: FileStorageService
    
    init(fileStorageSerivce: FileStorageService) {
        self.fileStorageSerivce = fileStorageSerivce
    }
    
    func saveCache(
        of fileName: String,
        from tmpURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        fileStorageSerivce.createDirectoryIfNeeded(AppConstants.Document.cacheDirectoryURL, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success:
                let cacheURL = AppConstants.Document.cacheDirectoryURL.appendingPathComponent(fileName)
                self.fileStorageSerivce.moveFile(from: tmpURL, to: cacheURL, removedIfDupplicate: true, completion: completion)
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
    
    
}
