//
//  GetListCacheSongUseCaseTest.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import XCTest

@testable import BLMusic

class GetListCacheSongUseCaseTest: XCTestCase {
    private var useCase: GetListCacheSongUseCase!
    private var songRepository: SongRepositoryMock!
    
    override func setUp() {
        songRepository = SongRepositoryMock()
        useCase = GetListCacheSongUseCaseImpl(songRepository: songRepository)
    }
    
    override func tearDown() {
        useCase = nil
        songRepository = nil
    }
}

extension GetListCacheSongUseCaseTest {
    func testLoadCacheSongSuccess() {
        // Given
        let mockEntities = MockSongProvider.provideCacheSongEntities(numOfItems: 5, cacheURL: "/User/Documents")
        songRepository.listMock = [.getListLocalSong(.success(mockEntities))]
        
        let localSongExpectation = XCTestExpectation(description: "Get local songs")
        
        // When
        useCase.getListCacheSong(
            completion: { result in
                guard case .success(let fetchedSong) = result else {
                    return
                }
                
                XCTAssertTrue(mockEntities.count == fetchedSong.count)
                
                let firstEntity = mockEntities.first!
                let firstFetchedSong = fetchedSong.first!
                
                XCTAssertEqual(firstEntity.id, firstFetchedSong.id)
                XCTAssertEqual(firstEntity.name, firstFetchedSong.name)
                XCTAssertEqual(firstEntity.url, firstFetchedSong.url)
                XCTAssertEqual(firstEntity.cacheURL, firstFetchedSong.cacheURL)
                
                localSongExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [localSongExpectation], timeout: 1.0)
    }
    
    func testLoadCacheSongWithErrorFromPersistentStorage() {
        // Given
        songRepository.listMock = [.getListLocalSong(.failure(CoreDataStorageError.somethingWentWrong))]
        
        let loadLocalSongErrorExpectation = XCTestExpectation(description: "Get local songs but returns error")
        
        // When
        useCase.getListCacheSong(
            completion: { result in
                guard
                    case .failure(let error) = result,
                    let coreDataError = error as? CoreDataStorageError
                else {
                    return
                }
                
                switch coreDataError {
                case .somethingWentWrong:
                    loadLocalSongErrorExpectation.fulfill()
                default:
                    break
                }                
            }
        )
        
        // Then
        wait(for: [loadLocalSongErrorExpectation], timeout: 1.0)
    }
}
