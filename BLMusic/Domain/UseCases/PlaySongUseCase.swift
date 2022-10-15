//
//  PlaySongUseCase.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol PlaySongUseCase {
    var audioService: AudioService { get }
    
    func play(song: Song, completion: @escaping (Result<Bool, Error>) -> Void)
    func stopPlaying(completion: @escaping (Result<Bool, Never>) -> Void)
}

final class PlaySongUseCaseImpl: PlaySongUseCase {
    let audioService: AudioService
    
    init(audioService: AudioService) {
        self.audioService = audioService
    }
    
    func play(song: Song, completion: @escaping (Result<Bool, Error>) -> Void) {
        audioService.playSong(song.cacheURL, completion: completion)
    }
    
    func stopPlaying(completion: @escaping (Result<Bool, Never>) -> Void) {
        audioService.stopPlaying(completion: completion)
    }
}
