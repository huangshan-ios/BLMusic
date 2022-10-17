//
//  GetListSongUseCaseTest.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import XCTest

@testable import BLMusic

class GetListSongUseCaseTest: XCTestCase {
    private var useCase: GetListSongUseCase!
    private var songRepository: SongRepositoryMock!
    
    override func setUp() {
        songRepository = SongRepositoryMock()
        useCase = GetListSongUseCaseImpl(songRepository: songRepository)
    }
    
    override func tearDown() {
        useCase = nil
        songRepository = nil
    }
}

extension GetListSongUseCaseTest {
    func testGetListSongWithoutCacheSuccess() {
        // Given
        let mockSongs = MockSongProvider.provideSongDTOs(numOfItems: 8)
        songRepository.listMock = [.getListSong(.success(mockSongs))]
        
        let listSongExpectation = XCTestExpectation(description: "Get list song")
        
        // Then
        _ = useCase.getListSong(
            baseOn: [],
            completion: { result in
                guard case .success(let fetchedSongs) = result else {
                    return
                }
                
                XCTAssertEqual(mockSongs.count, fetchedSongs.count)
                
                let firstMockSong = mockSongs.first!
                let firstFetchedSong = fetchedSongs.first!
                
                XCTAssertEqual(firstMockSong.id, firstFetchedSong.id)
                XCTAssertEqual(firstMockSong.name, firstFetchedSong.name)
                XCTAssertEqual(firstMockSong.url, firstFetchedSong.url)
                XCTAssertTrue(firstFetchedSong.state.isOnCloud)
                XCTAssertNil(firstFetchedSong.cacheURL)
                
                listSongExpectation.fulfill()
            }
        )
        
        // When
        wait(for: [listSongExpectation], timeout: 1.0)
    }
    
    func testGetListSongWithCacheSuccess() {
        // Given
        let mockSongs = MockSongProvider.provideSongDTOs(numOfItems: 8)
        let mockCacheSongs = MockSongProvider.provideMockCacheSong(numOfItems: 4, cacheURL: "/User/Documents")
        
        songRepository.listMock = [.getListSong(.success(mockSongs))]
        
        let listSongExpectation = XCTestExpectation(description: "Get list song")
        
        // Then
        _ = useCase.getListSong(
            baseOn: mockCacheSongs,
            completion: { result in
                guard case .success(let fetchedSongs) = result else {
                    return
                }
                
                XCTAssertEqual(mockSongs.count, fetchedSongs.count)
                
                let firstMockSong = mockCacheSongs.first!
                let firstFetchedSong = fetchedSongs.first!
                
                XCTAssertEqual(firstMockSong.id, firstFetchedSong.id)
                XCTAssertEqual(firstMockSong.name, firstFetchedSong.name)
                XCTAssertEqual(firstMockSong.url, firstFetchedSong.url)
                XCTAssertEqual(firstMockSong.cacheURL, firstFetchedSong.cacheURL)
                XCTAssertTrue(firstFetchedSong.state.isReady)
                
                if fetchedSongs.count > mockCacheSongs.count {
                    let lastMockSong = mockSongs.last!
                    let lastFetchedSong = fetchedSongs.last!
                    
                    XCTAssertEqual(lastMockSong.id, lastFetchedSong.id)
                    XCTAssertEqual(lastMockSong.name, lastFetchedSong.name)
                    XCTAssertEqual(lastMockSong.url, lastFetchedSong.url)
                    XCTAssertTrue(lastFetchedSong.state.isOnCloud)
                    XCTAssertNil(lastFetchedSong.cacheURL)
                }
                
                listSongExpectation.fulfill()
            }
        )
        
        // When
        wait(for: [listSongExpectation], timeout: 1.0)
    }
    
    func testGetListSongWithErrorFromNetwork() {
        // Given
        songRepository.listMock = [.getListSong(.failure(NetworkError.invalidURL))]
        
        let loadSongsErrorExpectation = XCTestExpectation(description: "Get songs but returns error")
        
        // When
        _ = useCase.getListSong(
            baseOn: [],
            completion: { result in
                guard
                    case .failure(let error) = result,
                    let networkError = error as? NetworkError
                else {
                    return
                }
                
                switch networkError {
                case .invalidURL:
                    loadSongsErrorExpectation.fulfill()
                default:
                    break
                }
            }
        )
        
        // Then
        wait(for: [loadSongsErrorExpectation], timeout: 1.0)
    }
}
