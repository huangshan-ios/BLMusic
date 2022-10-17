//
//  SongRepository.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol SongRepository {
    func getListLocalSong(completion: @escaping (Result<[SongEntity], Error>) -> Void)
    
    func getListSong(
        completion: @escaping (Result<[SongDTO], Error>) -> Void
    ) -> Cancellable?
    
    // TODO: Consider to create Repository for this one
    func downloadSong(
        _ song: SongDTO,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
    
    // TODO: Consider to create Repository for this one
    func saveSongToPersistentStorage(
        _ song: SongDTO,
        audioCacheURL: URL,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SongRepositoryImpl: SongRepository {
    private let networkService: NetworkSevice
    private let downloadFileService: DownloadFileService
    private let songsStorage: SongsStorage
    
    init(
        networkService: NetworkSevice,
        downloadFileService: DownloadFileService,
        songsStorage: SongsStorage
    ) {
        self.networkService = networkService
        self.downloadFileService = downloadFileService
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
            fileName: song.audioFileName(),
            from: song.url,
            to: AppConstants.Document.cacheDirectoryURL,
            removeIfDupplicate: true,
            progressHandler: progressHandler,
            completionHandler: completionHandler
        )
        return task
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
