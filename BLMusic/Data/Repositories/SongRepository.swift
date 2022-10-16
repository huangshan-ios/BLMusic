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
    var songsStorage: SongsStorage { get }
    
    func getListLocalSong(completion: @escaping (Result<[SongEntity], Error>) -> Void)
    
    func getListSong(
        completion: @escaping (Result<[SongDTO], Error>) -> Void
    ) -> Cancellable?
    
    func downloadSong(
        _ song: SongDTO,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
    
    func saveAudioFileToCache(
        of song: SongDTO,
        in tmpURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    )
    
    func saveSongToPersistentStorage(
        _ song: SongDTO,
        audioCacheURL: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SongRepositoryImpl: SongRepository {
    let networkService: NetworkSevice
    let downloadFileService: DownloadFileService
    let fileManagerService: FileManagerService
    let songsStorage: SongsStorage
    
    init(
        networkService: NetworkSevice,
        downloadFileService: DownloadFileService,
        fileManagerService: FileManagerService,
        songsStorage: SongsStorage
    ) {
        self.networkService = networkService
        self.downloadFileService = downloadFileService
        self.fileManagerService = fileManagerService
        self.songsStorage = songsStorage
    }
    
    func getListLocalSong(completion: @escaping (Result<[SongEntity], Error>) -> Void) {
        songsStorage.getListSongEntity(completion: completion)
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
        _ song: SongDTO,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        task.serviceTask = downloadFileService.downloadFile(
            from: song.url,
            progressHandler: progressHandler,
            completionHandler: completionHandler
        )
        return task
    }
    
    func saveAudioFileToCache(
        of song: SongDTO,
        in tmpURL: URL,
        completion: @escaping (Result<URL, Error>) -> Void
    ) {
        let cacheDirectory = AppConstants.Document.cacheDirectoryURL
        let fileName = song.name.replacingOccurrences(of: " ", with: "_").appending(".mp3")
        let cacheURL = cacheDirectory.appendingPathComponent(fileName)
        fileManagerService.createDirectoryIfNeeded(
            cacheDirectory,
            completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success:
                    self.fileManagerService.moveFile(
                        from: tmpURL,
                        to: cacheURL,
                        removedIfDupplicate: true,
                        completion: completion
                    )
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
    
    func saveSongToPersistentStorage(
        _ song: SongDTO,
        audioCacheURL: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        songsStorage.save(
            song,
            cacheURL: audioCacheURL,
            completion: completion
        )
    }
}
