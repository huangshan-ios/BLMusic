//
//  FileStorageService.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

protocol FileStorageService {
    var fileManager: FileManager { get }
    
    func createDirectoryIfNeeded(_ directoryURL: URL, completion: @escaping (Result<Void, Error>) -> Void)
    
    func moveFile(
        from current: URL,
        to destination: URL,
        removedIfDupplicate: Bool,
        completion: @escaping (Result<URL, Error>) -> Void
    )
}

final class FileStorageServiceImpl: FileStorageService {
    
    let fileManager: FileManager
    
    init(fileManager: FileManager = FileManager()) {
        self.fileManager = fileManager
    }
    
    func createDirectoryIfNeeded(
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
            completion(.failure(FileStorageError.other(error)))
        }
    }
    
    func moveFile(
        from current: URL,
        to destination: URL,
        removedIfDupplicate: Bool,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        do {
            if fileManager.fileExists(atPath: destination.path) {
                if removedIfDupplicate {
                    try fileManager.removeItem(at: destination)
                } else {
                    completion(.failure(FileStorageError.fileExist))
                    return
                }
            }
            try fileManager.moveItem(at: current, to: destination)
            completion(.success(destination))
        } catch let error {
            completion(.failure(FileStorageError.other(error)))
        }
    }
}
