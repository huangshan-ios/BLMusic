//
//  DependenciesProvider.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

class DependenciesProvider {
    
    static var networkService: NetworkSevice = NetworkServiceImpl()

    class func provideSongListViewModel() -> SongListViewModel {
        let songRepository = SongRepositoryImpl(networkService: networkService)
        let getListSongUseCase = GetListSongUseCaseImpl(songRepository: songRepository)
        return SongListViewModel(getListSongUseCase: getListSongUseCase,
                                 downloadSongUseCase: DownloadSongUseCaseImpl(),
                                 playSongUseCase: PlaySongUseCaseImpl())
    }
    
    class func provideSongListCoordinator() -> SongListCoordinator {
        return SongListCoordinator()
    }
}
