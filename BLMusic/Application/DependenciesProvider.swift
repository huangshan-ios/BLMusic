//
//  DependenciesProvider.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

class DependenciesProvider {

    class func provideSongListViewModel() -> SongListViewModel {
        let networkService = NetworkServiceImpl()
        let downloadFileService = DownloadFileServiceImpl()
        let fileStorageService = FileStorageServiceImpl()
        
        let songRepository = SongRepositoryImpl(networkService: networkService, downloadFileService: downloadFileService)
        let fileRepository = FileRepositoryImpl(fileStorageSerivce: fileStorageService)
        
        let getListSongUseCase = GetListSongUseCaseImpl(songRepository: songRepository)
        let downLoadSongUseCase = DownloadSongUseCaseImpl(songRepository: songRepository,fileRepository: fileRepository)
        
        return SongListViewModel(getListSongUseCase: getListSongUseCase,
                                 downloadSongUseCase: downLoadSongUseCase,
                                 playSongUseCase: PlaySongUseCaseImpl())
    }
    
    class func provideSongListCoordinator() -> SongListCoordinator {
        return SongListCoordinator()
    }
}
