//
//  SongListViewModel.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

final class SongListViewModel: ViewModelType {
    
    private let getListSongUseCase: GetListSongUseCase
    private let downloadSongUseCase: DownloadSongUseCase
    private let playSongUseCase: PlaySongUseCase
    
    private var getListSongCancellable: Cancellable? {
        willSet {
            getListSongCancellable?.cancel()
        }
    }
    
    private var downloadSongCancellables: [String: Cancellable?] = [:]
    
    private var songs: [Song] = []
    
    var loadSongsObservable: (() -> Void)?
    var songStateObservable: ((Int) -> Void)?
    
    var loadingObservable: ((Bool) -> Void)?
    var errorObservable: ((Error) -> Void)?
    
    init(
        getListSongUseCase: GetListSongUseCase,
        downloadSongUseCase: DownloadSongUseCase,
        playSongUseCase: PlaySongUseCase
    ) {
        self.getListSongUseCase = getListSongUseCase
        self.downloadSongUseCase = downloadSongUseCase
        self.playSongUseCase = playSongUseCase
    }
    
    func loadNewSongs() {
        loadingObservable?(true)
        getListSongCancellable = getListSongUseCase.getListSong { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case.success(let songs):
                self.songs = songs
                self.loadSongsObservable?()
            case .failure(let error):
                self.errorObservable?(error)
            }
            self.loadingObservable?(false)
            self.getListSongCancellable = nil
        }
    }
    
    func getSongs() -> [Song] {
        return songs
    }
    
    func downloadSong(at index: Int) {
        let song = songs[index]
        update(songState: .downloading(0), at: index)
        
        let cancellable = downloadSongUseCase.downloadSong(
            song,
            progressHander: { [weak self] progress in
                guard let self = self else {
                    return
                }
                self.update(songState: .downloading(progress), at: index)
            }, completionHandler: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let cacheURL):
                    self.update(songState: .downloaded, and: cacheURL, at: index)
                    self.downloadSongCancellables[song.url]??.cancel()
                case .failure(let error):
                    self.errorObservable?(error)
                }
                
            })
        
        downloadSongCancellables[song.url] = cancellable
    }
    
    private func update(songState newState: Song.State, and url: URL? = nil, at index: Int) {
        songs.update(newState, url: url, at: index)
        songStateObservable?(index)
    }
}
