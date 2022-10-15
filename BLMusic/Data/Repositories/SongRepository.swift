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
    
    func getListSong(completion: @escaping (Result<[SongDTO], Error>) -> Void) -> Cancellable?
    func downloadSong(
        from url: String,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable?
}

final class SongRepositoryImpl: SongRepository {
    let networkService: NetworkSevice
    let downloadFileService: DownloadFileService
    
    init(
        networkService: NetworkSevice,
        downloadFileService: DownloadFileService
    ) {
        self.networkService = networkService
        self.downloadFileService = downloadFileService
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
        from url: String,
        progressHandler: @escaping (Double) -> Void,
        completionHandler: @escaping (Result<URL, Error>) -> Void
    ) -> Cancellable? {
        let task = RepositoryTask()
        task.serviceTask = downloadFileService.downloadFile(from: url,
                                                            progressHandler: progressHandler,
                                                            completionHandler: completionHandler)
        return task
    }
}
