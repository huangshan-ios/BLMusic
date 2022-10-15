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
        let audioService = AudioServiceImpl()
        
        let songRepository = SongRepositoryImpl(networkService: networkService, downloadFileService: downloadFileService)
        
        let getListSongUseCase = GetListSongUseCaseImpl(songRepository: songRepository)
        let downLoadSongUseCase = DownloadSongUseCaseImpl(songRepository: songRepository,
                                                          fileManagerService: fileManagerService)
        let playSongUseCase = PlaySongUseCaseImpl(audioService: audioService)
        
        return SongListViewModel(getListSongUseCase: getListSongUseCase,
                                 downloadSongUseCase: downLoadSongUseCase,
                                 playSongUseCase: playSongUseCase)
    }
    
    class func provideSongListCoordinator() -> SongListCoordinator {
        return SongListCoordinator()
    }
}
