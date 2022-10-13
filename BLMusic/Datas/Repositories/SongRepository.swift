//
//  SongRepository.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol SongRepository {
    var networkService: NetworkSevice { get }
    
    func getListSong(completion: @escaping (Result<[SongDTO], Error>) -> Void)
}

final class SongRepositoryImpl: SongRepository {
    let networkService: NetworkSevice
    
    init(networkService: NetworkSevice) {
        self.networkService = networkService
    }
    
    func getListSong(completion: @escaping (Result<[SongDTO], Error>) -> Void) {
        networkService.request(SongsRequest(), completion: { (result: Result<DataDTO<[SongDTO]>, Error>) in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
