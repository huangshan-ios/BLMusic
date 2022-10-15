//
//  Error+Extensions.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

extension Error {
    func asCommonUIError() -> CommonUIError {
        if let networkError = self as? NetworkError {
            switch networkError {
            case .invalidRequest(let error),
                    .invalidResponse(let error),
                    .other(let error):
                return CommonUIError(id: (error as NSError).code,
                                     message: error.localizedDescription)
            case .invalidJSON, .invalidURL, .somethingWentWrong:
                return CommonUIError.somethingWhenWrong
            }
        }
        
        if let downloadError = self as? DownloadError {
            switch downloadError {
            case .somethingWentWrong, .invalidURL:
                return CommonUIError.somethingWhenWrong
            case .other(let error):
                return CommonUIError(id: (error as NSError).code,
                                     message: error.localizedDescription)
            }
        }
        
        if let fileStorageError = self as? FileStorageError {
            switch fileStorageError {
            case .fileExist, .somethingWentWrong:
                return CommonUIError.somethingWhenWrong
            case .other(let error):
                return CommonUIError(id: (error as NSError).code,
                                     message: error.localizedDescription)
            }
        }
        
        if let audioError = self as? AudioError {
            switch audioError {
            case .invalidURL, .somethingWentWrong:
                return CommonUIError.somethingWhenWrong
            case .other(let error):
                return CommonUIError(id: (error as NSError).code,
                                     message: error.localizedDescription)
            }
        }
        
        if let coreDataError = self as? CoreDataStorageError {
            switch coreDataError {
            case .other(let error):
                return CommonUIError(id: (error as NSError).code,
                                     message: error.localizedDescription)
            default:
                return CommonUIError.somethingWhenWrong
            }
        }
        
        return CommonUIError.somethingWhenWrong
    }
}


