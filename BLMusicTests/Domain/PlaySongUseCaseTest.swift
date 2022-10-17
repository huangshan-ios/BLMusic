//
//  PlaySongUseCaseTest.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import XCTest

@testable import BLMusic

class PlaySongUseCaseTest: XCTestCase {
    private var useCase: PlaySongUseCase!
    private var audioService: AudioServiceMock!
    
    override func setUp() {
        audioService = AudioServiceMock()
        useCase = PlaySongUseCaseImpl(audioService: audioService)
    }
    
    override func tearDown() {
        useCase = nil
        audioService = nil
    }
}

extension PlaySongUseCaseTest {
    func testPlaySongSuccess() {
        // Given
        let song = MockSongProvider.provideMockSongs(numOfItems: 1).first!
        audioService.listMock = [.playSong(.success(true))]
        
        let playingExpectation = XCTestExpectation(description: "Playing song")
        
        // When
        useCase.play(
            song: song,
            completion: { result in
                guard case .success(let isPlaying) = result, isPlaying else {
                    return
                }
                
                playingExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [playingExpectation], timeout: 1.0)
    }
    
    func testPlayingWithError() {
        // Given
        let song = MockSongProvider.provideMockSongs(numOfItems: 1).first!
        audioService.listMock = [.playSong(.failure(AudioError.somethingWentWrong))]
        
        let errorExpectation = XCTestExpectation(description: "Playing song error")
        
        // When
        useCase.play(
            song: song,
            completion: { result in
                guard
                    case .failure(let error) = result,
                    let audioError = error as? AudioError
                else {
                    return
                }
                
                switch audioError {
                case .somethingWentWrong:
                    errorExpectation.fulfill()
                default:
                    break
                }
            }
        )
        
        // Then
        wait(for: [errorExpectation], timeout: 1.0)
    }
    
    func testStopPlayingSuccess() {
        // Given
        audioService.listMock = [.stopPlaying(.success(true))]
        
        let stopPlayingExpectation = XCTestExpectation(description: "Stop playing song")
        
        // When
        useCase.stopPlaying(
            completion: { result in
                guard case .success(let isNotPlaying) = result, isNotPlaying else {
                    return
                }
                
                stopPlayingExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [stopPlayingExpectation], timeout: 1.0)
    }
}
