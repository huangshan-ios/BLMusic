//
//  DownloadFileService.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

protocol DownloadFileService {
    func downloadFile(
        fileName: String,
        from url: String,
        to directory: URL,
        removeIfDupplicate: Bool,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> DownloadCancellable?
}

final class DownloadFileServiceImpl: DownloadFileService {
    
    private lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        return operationQueue
    }()
    
    private lazy var fileManager: FileManager = {
        return FileManager()
    }()
    
    
    // TODO: Enhance this function by move FileManager out define it as a dependency
    // It's will help to write unit test for all of dependency
    
    func downloadFile(
        fileName: String,
        from url: String,
        to directory: URL,
        removeIfDupplicate: Bool = true,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> DownloadCancellable? {
        guard let url = URL(string: url) else {
            completionHandler(.failure(DownloadError.invalidURL))
            return nil
        }
        
        let downloadOperation = DownloadOperation(
            downloadTaskURL: url,
            progressHandler: { progress in
                progressHandler(progress)
            }, downloadHandler: { [weak self] temporaryURL, _, error in
                guard let self = self else {
                    return
                }
                
                if let error = error {
                    completionHandler(.failure(error))
                } else if let temporaryURL = temporaryURL {
                    
                    self.createDirectoryIfNeeded(
                        directory,
                        completion: { [weak self] result in
                            guard let self = self else {
                                return
                            }
                            
                            switch result {
                            case .success:
                                self.moveFile(
                                    fileName: fileName,
                                    from: temporaryURL,
                                    to: directory,
                                    removeIfDupplicate: removeIfDupplicate,
                                    completion: completionHandler)
                            case .failure(let error):
                                completionHandler(.failure(error))
                            }
                        }
                    )
                    
                } else {
                    completionHandler(.failure(DownloadError.somethingWentWrong))
                }
            }
        )
        
        operationQueue.addOperation(downloadOperation)
        
        return downloadOperation
    }
}

// MARK: Private functions
extension DownloadFileServiceImpl {
    private func createDirectoryIfNeeded(
        _ directoryURL: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        var isDir: ObjCBool = true
        if fileManager.fileExists(atPath: directoryURL.path, isDirectory: &isDir) {
            completion(.success(()))
            return
        }
        
        do {
            try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            completion(.success(()))
        } catch let error {
            completion(.failure(DownloadError.other(error)))
        }
    }
    
    private func moveFile(
        fileName: String,
        from tempURL: URL,
        to destinationDirectory: URL,
        removeIfDupplicate: Bool,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let destinationURL = destinationDirectory.appendingPathComponent(fileName)
        do {
            if fileManager.fileExists(atPath: destinationURL.path) {
                if removeIfDupplicate {
                    try fileManager.removeItem(at: destinationURL)
                } else {
                    completion(.failure(DownloadError.fileExist))
                    return
                }
            }
            try fileManager.moveItem(at: tempURL, to: destinationURL)
            completion(.success(destinationURL))
        } catch let error {
            completion(.failure(DownloadError.other(error)))
        }
    }
}
