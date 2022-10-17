//
//  ListSongViewModel.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

final class ListSongViewModel: ViewModelType {
    
    private let getListCacheSongUseCase: GetListCacheSongUseCase
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
    
    private var currentPlayIndex: Int? = nil
    
    // TODO: Enhance below closures by using Observer pattern
    var loadSongsObservable: (() -> Void)?
    var songStateObservable: ((Int) -> Void)?
    
    var loadingObservable: ((Bool) -> Void)?
    var errorObservable: ((Error) -> Void)?
    
    init(
        getListCacheSongUseCase: GetListCacheSongUseCase,
        getListSongUseCase: GetListSongUseCase,
        downloadSongUseCase: DownloadSongUseCase,
        playSongUseCase: PlaySongUseCase
    ) {
        self.getListCacheSongUseCase = getListCacheSongUseCase
        self.getListSongUseCase = getListSongUseCase
        self.downloadSongUseCase = downloadSongUseCase
        self.playSongUseCase = playSongUseCase
    }
    
    func loadSongs() {
        loadingObservable?(true)
        getListCacheSongUseCase.getListCacheSong { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let songs):
                self.songs = songs
                self.loadSongsObservable?()
                self.loadNewSongs(baseOn: songs)
            case .failure(let error):
                self.errorObservable?(error)
            }
        }
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
                // Cause the song is download too fast then you can use this print to check if the song is not simultaneously downloaded
                // print("Progress of \(song.name) is: \(progress)")
                self.update(songState: .downloading(progress), at: index)
            }, completionHandler: { [weak self] result in
                guard let self = self else {
                    return
                }
                
                switch result {
                case .success(let cacheURL):
                    self.update(songState: .ready, and: cacheURL, at: index)
                    self.downloadSongCancellables[song.url]??.cancel()
                case .failure(let error):
                    self.errorObservable?(error)
                }
            }
        )
        
        downloadSongCancellables[song.url] = cancellable
    }
    
    /*
     This is a function for cancel download file
     func cancelDownloadSong(at index: Int) {
     let song = songs[index]
     downloadSongCancellables[song.url]??.cancel()
     update(songState: .onCloud, and: nil, at: index)
     }
     */
    
    /// This function will throw error everytime you play a song in simulator if you rebuild the app with Xcode, even you already download the file
    /// The reason is becaus the NSHomeDirectory() of simulator is always changes after each build with Xcode
    func playSong(at index: Int) {
        playSongUseCase.play(song: songs[index]) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let isPlaying):
                guard isPlaying else {
                    return
                }
                if self.currentPlayIndex != nil {
                    self.update(songState: .ready, at: self.currentPlayIndex!)
                }
                
                self.currentPlayIndex = index
                self.update(songState: .playing, at: index)
            case .failure(let error):
                self.errorObservable?(error)
            }
        }
    }
    
    func stopPlay(at index: Int) {
        playSongUseCase.stopPlaying(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let isPlaying):
                guard !isPlaying else {
                    return
                }
                self.update(songState: .ready, at: index)
            }
        })
    }
}

// MARK: Util funtions
extension ListSongViewModel {
    func getSongs() -> [Song] {
        return songs
    }
}

// MARK: Private functions
extension ListSongViewModel {
    private func loadNewSongs(baseOn cacheSongs: [Song]) {
        getListSongCancellable = getListSongUseCase.getListSong(
            baseOn: cacheSongs,
            completion: { [weak self] result in
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
        )
    }
    
    private func update(songState newState: Song.State, and url: URL? = nil, at index: Int) {
        songs.update(newState, url: url, at: index)
        songStateObservable?(index)
    }
}
