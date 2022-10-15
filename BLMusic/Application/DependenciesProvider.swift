//
//  DependenciesProvider.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

class DependenciesProvider {
    
    // TODO: Enhance this DI by simple Dependency Injection Stack if more than 2 screens.
    class func provideSongListViewModel() -> SongListViewModel {
        let networkService = NetworkServiceImpl()
        let downloadFileService = DownloadFileServiceImpl()
        let fileManagerService = FileManagerServiceImpl()
        let songsStorageImpl = SongsStorageImpl()
        let audioService = AudioServiceImpl()
        
        let songRepository = SongRepositoryImpl(networkService: networkService,
                                                downloadFileService: downloadFileService,
                                                fileManagerService: fileManagerService,
                                                songsStorage: songsStorageImpl)
        
        let getListCacheSongUseCase = GetListCacheSongUseCaseImpl(songRepository: songRepository)
        let getListSongUseCase = GetListSongUseCaseImpl(songRepository: songRepository)
        let downLoadSongUseCase = DownloadSongUseCaseImpl(songRepository: songRepository)
        let playSongUseCase = PlaySongUseCaseImpl(audioService: audioService)
        
        return SongListViewModel(getListCacheSongUseCase: getListCacheSongUseCase,
                                 getListSongUseCase: getListSongUseCase,
                                 downloadSongUseCase: downLoadSongUseCase,
                                 playSongUseCase: playSongUseCase)
    }
    
    class func provideSongListCoordinator() -> SongListCoordinator {
        return SongListCoordinator()
    }
}
