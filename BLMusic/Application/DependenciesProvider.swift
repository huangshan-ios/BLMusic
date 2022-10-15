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
        let fileManagerService = FileManagerServiceImpl()
        let localDatabaseService = LocalDatabaseServiceImpl()
        let audioService = AudioServiceImpl()
        
        let songRepository = SongRepositoryImpl(networkService: networkService,
                                                downloadFileService: downloadFileService,
                                                fileManagerService: fileManagerService,
                                                localDatabaseService: localDatabaseService)
        
        let getListSongUseCase = GetListSongUseCaseImpl(songRepository: songRepository)
        let downLoadSongUseCase = DownloadSongUseCaseImpl(songRepository: songRepository)
        let playSongUseCase = PlaySongUseCaseImpl(audioService: audioService)
        
        return SongListViewModel(getListSongUseCase: getListSongUseCase,
                                 downloadSongUseCase: downLoadSongUseCase,
                                 playSongUseCase: playSongUseCase)
    }
    
    class func provideSongListCoordinator() -> SongListCoordinator {
        return SongListCoordinator()
    }
}
