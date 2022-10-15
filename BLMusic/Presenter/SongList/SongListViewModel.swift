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
        let cancellable = downloadSongUseCase.downloadSong(song) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let state):
                print("State \(state)")
                let song = Song(id: song.id, name: song.name, url: song.url, state: state)
                self.songs.remove(at: index)
                self.songs.insert(song, at: index)
                if state.isDownloaded {
                    self.downloadSongCancellables[song.url]??.cancel()
                }
                self.songStateObservable?(index)
            case .failure(let error):
                print("error \(error)")
                self.errorObservable?(error)
            }
            
        }
        downloadSongCancellables[song.url] = cancellable
    }

}
