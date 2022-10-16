//
//  DependenciesProvider.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

class DependenciesProvider {
    
    // TODO: Enhance this DI by simple Dependency Injection Stack if more than 2 screens.
    class func provideListSongViewModel() -> ListSongViewModel {
        let networkService = NetworkServiceImpl()
        let downloadFileService = DownloadFileServiceImpl()
        let songsStorageImpl = SongsStorageImpl()
        let audioService = AudioServiceImpl()
        
        let songRepository = SongRepositoryImpl(networkService: networkService,
                                                downloadFileService: downloadFileService,
                                                songsStorage: songsStorageImpl)
        
        let getListCacheSongUseCase = GetListCacheSongUseCaseImpl(songRepository: songRepository)
        let getListSongUseCase = GetListSongUseCaseImpl(songRepository: songRepository)
        let downLoadSongUseCase = DownloadSongUseCaseImpl(songRepository: songRepository)
        let playSongUseCase = PlaySongUseCaseImpl(audioService: audioService)
        
        return ListSongViewModel(getListCacheSongUseCase: getListCacheSongUseCase,
                                 getListSongUseCase: getListSongUseCase,
                                 downloadSongUseCase: downLoadSongUseCase,
                                 playSongUseCase: playSongUseCase)
    }
    
    class func provideListSongCoordinator() -> ListSongCoordinator {
        return ListSongCoordinator()
    }
}
