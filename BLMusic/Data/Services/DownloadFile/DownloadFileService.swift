//
//  DownloadFileService.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

protocol DownloadFileService {
    var operationQueue: OperationQueue { get }
    
    func downloadFile(
        from url: String,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> DownloadCancellable?
}

final class DownloadFileServiceImpl: DownloadFileService {
    
    lazy var operationQueue: OperationQueue = {
        let operationQueue = OperationQueue()
        return operationQueue
    }()
    
    func downloadFile(
        from url: String,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> DownloadCancellable? {
        guard let url = URL(string: url) else {
            completionHandler(.failure(DownloadError.invalidURL))
            return nil
        }
        
        let downloadOperation = DownloadOperation(downloadTaskURL: url, progressHandler: { progress in
            progressHandler(progress)
        }, downloadHandler: { temporaryURL, _, error in
            if let error = error {
                completionHandler(.failure(error))
            } else if let temporaryURL = temporaryURL {
                completionHandler(.success(temporaryURL))
            } else {
                completionHandler(.failure(DownloadError.somethingWentWrong))
            }
        })
        
        operationQueue.addOperation(downloadOperation)
        
        return downloadOperation
    }
    
}
