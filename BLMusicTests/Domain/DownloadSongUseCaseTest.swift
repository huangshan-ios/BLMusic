//
//  DownloadSongUseCaseTest.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import XCTest

@testable import BLMusic

class DownloadSongUseCaseTest: XCTestCase {
    private var useCase: DownloadSongUseCase!
    private var songRepository: SongRepositoryMock!
    
    override func setUp() {
        songRepository = SongRepositoryMock()
        useCase = DownloadSongUseCaseImpl(songRepository: songRepository)
    }
    
    override func tearDown() {
        useCase = nil
        songRepository = nil
    }
}

extension DownloadSongUseCaseTest {
    func testDownloadSongSuccess() {
        // Given
        let song = MockSongProvider.provideMockSongs(numOfItems: 1).first!
        let cacheURL = URL(string: "file://User/Documents")!
        
        songRepository.listMock = [.downloadSong(.success(cacheURL)), .saveSongToPersistentStorage(.success(()))]
        
        let progressExpectation = XCTestExpectation(description: "Receive download progress")
        let responseExpectation = XCTestExpectation(description: "Download song done")
        
        // When
        _ = useCase.downloadSong(
            song,
            progressHander: { progress in
                progressExpectation.fulfill()
            }, completionHandler: { result in
                guard case .success(let audioCacheURL) = result else {
                    return
                }
                
                XCTAssertEqual(cacheURL.path, audioCacheURL.path)
                responseExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [progressExpectation, responseExpectation], timeout: 1.0)
    }
    
    func testDownloadSongWithErrorFromNetwork() {
        // Given
        let song = MockSongProvider.provideMockSongs(numOfItems: 1).first!
        
        songRepository.listMock = [.downloadSong(.failure(DownloadError.somethingWentWrong))]
        
        let networkErrorExpectation = XCTestExpectation(description: "Download song error")
        
        // When
        _ = useCase.downloadSong(
            song,
            progressHander: { _ in },
            completionHandler: { result in
                guard
                    case .failure(let error) = result,
                    let downloadError = error as? DownloadError
                else {
                    return
                }
                
                switch downloadError {
                case .somethingWentWrong:
                    networkErrorExpectation.fulfill()
                default:
                    break
                }
            }
        )
        
        // Then
        wait(for: [networkErrorExpectation], timeout: 1.0)
    }
    
    func testDownloadSongWithErrorFromPersistentStorage() {
        // Given
        let song = MockSongProvider.provideMockSongs(numOfItems: 1).first!
        let cacheURL = URL(string: "file://User/Documents")!
        
        songRepository.listMock = [
            .downloadSong(.success(cacheURL)),
            .saveSongToPersistentStorage(.failure(CoreDataStorageError.somethingWentWrong))
        ]
        
        let progressExpectation = XCTestExpectation(description: "Receive download progress")
        let coreDataErrorExpectation = XCTestExpectation(description: "Download song error")
        
        // When
        _ = useCase.downloadSong(
            song,
            progressHander: { _ in
                progressExpectation.fulfill()
            },
            completionHandler: { result in
                guard
                    case .failure(let error) = result,
                    let coreDataStorageError = error as? CoreDataStorageError
                else {
                    return
                }
                
                switch coreDataStorageError {
                case .somethingWentWrong:
                    coreDataErrorExpectation.fulfill()
                default:
                    break
                }
            }
        )
        
        // Then
        wait(for: [coreDataErrorExpectation], timeout: 1.0)
    }
}
