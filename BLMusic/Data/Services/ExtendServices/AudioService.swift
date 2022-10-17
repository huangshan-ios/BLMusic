//
//  AudioService.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import AVFoundation
import AVFAudio

/*
 * Actually, we don't need to create this service, we can replace it by a singleton like:
 
    final class AudioManagerHelper {
        static let shared = AudioManagerHelper()
    }
 
 * I just want to create this one cause I want to mock and test the instance will inject this ervice
 */

protocol AudioService {    
    func playSong(_ url: URL?, completion: @escaping (Result<Bool, Error>) -> Void)
    func stopPlaying(completion: @escaping (Result<Bool, Never>) -> Void)
}

final class AudioServiceImpl: AudioService {
    
    var audioPlayer: AVAudioPlayer?
    
    func playSong(_ url: URL?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = url else {
            completion(.failure(AudioError.invalidURL))
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            audioPlayer?.prepareToPlay()
            let isPlaying = audioPlayer?.play() ?? false
            completion(.success(isPlaying))
        } catch let error {
            completion(.failure(AudioError.other(error)))
        }
    }
    
    func stopPlaying(completion: @escaping (Result<Bool, Never>) -> Void) {
        audioPlayer?.stop()
        completion(.success(audioPlayer?.isPlaying ?? false))
    }
}
