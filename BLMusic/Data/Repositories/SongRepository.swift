//
//  SongRepository.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol SongRepository {
    var networkService: NetworkSevice { get }
    var downloadFileService: DownloadFileService { get }
    var fileManagerService: FileManagerService { get }
    var localDatabaseService: LocalDatabaseService { get }
    
    func getListLocalSong(completion: @escaping (Result<[LocalSongDTO], Error>) -> Void)
    
    func getListSong(
        completion: @escaping (Result<[SongDTO], Error>) -> Void
    ) -> Cancellable?
    
    func downloadSong(
        _ song: Song,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
    
    
}

final class SongRepositoryImpl: SongRepository {
    let networkService: NetworkSevice
    let downloadFileService: DownloadFileService
    let fileManagerService: FileManagerService
    let localDatabaseService: LocalDatabaseService
    
    init(
        networkService: NetworkSevice,
        downloadFileService: DownloadFileService,
        fileManagerService: FileManagerService,
        localDatabaseService: LocalDatabaseService
    ) {
        self.networkService = networkService
        self.downloadFileService = downloadFileService
        self.fileManagerService = fileManagerService
        self.localDatabaseService = localDatabaseService
    }
    
    func getListLocalSong(completion: @escaping (Result<[LocalSongDTO], Error>) -> Void) {
        
    }
    
    func getListSong(completion: @escaping (Result<[SongDTO], Error>) -> Void) -> Cancellable? {
        let request = SongsRequest()
        let task = RepositoryTask()
        task.serviceTask = networkService.request(request, completion: { (result: Result<DataDTO<[SongDTO]>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }
    
    func downloadSong(
        _ song: Song,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        task.serviceTask = downloadFileService.downloadFile(
            from: song.url,
            progressHandler: progressHandler,
            completionHandler: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case.success(let tmpURL):
                    let fileName = song.name.replacingOccurrences(of: " ", with: "_").appending(".mp3")
                    self.saveCache(of: fileName, in: tmpURL, completion: completionHandler)
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        )
        return task
    }
    
    private func saveCache(
        of fileName: String,
        in tmpURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let cacheDirectory = AppConstants.Document.cacheDirectoryURL
        fileManagerService.createDirectoryIfNeeded(
            cacheDirectory,
            completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success:
                    let cacheURL = cacheDirectory.appendingPathComponent(fileName)
                    self.fileManagerService.moveFile(from: tmpURL, to: cacheURL, removedIfDupplicate: true, completion: completion)
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}
