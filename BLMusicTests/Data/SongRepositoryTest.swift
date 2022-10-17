//
//  SongRepositoryTest.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import XCTest

@testable import BLMusic

class SongRepositoryTest: XCTestCase {
    private var repository: SongRepository!
    private var networkService: NetworkServiceMock!
    private var downloadService: DownloadServiceMock!
    private var songsStorage: SongsStorageMock!
    
    override func setUp() {
        networkService = NetworkServiceMock()
        downloadService = DownloadServiceMock()
        songsStorage = SongsStorageMock()
        
        repository = SongRepositoryImpl(
            networkService: networkService,
            downloadFileService: downloadService,
            songsStorage: songsStorage
        )
    }
    
    override func tearDown() {
        repository = nil
        networkService = nil
        downloadService = nil
        songsStorage = nil
    }
}

extension SongRepositoryTest {
    func testGetListLocalSongSuccess() {
        // Given
        let mockEntites = MockSongProvider.provideCacheSongEntities(numOfItems: 8, cacheURL: "/User/Documents")
        songsStorage.listMock = [.getListSongEntity(.success(mockEntites))]
        
        let localSongsExpectation = XCTestExpectation(description: "Get local songs")
        
        // When
        repository.getListLocalSong(
            completion: { result in
                guard case .success(let entities) = result else {
                    return
                }
                
                let firstMockEntity = mockEntites.first!
                let firstEntity = entities.first!
                
                XCTAssertEqual(firstEntity.id, firstMockEntity.id)
                XCTAssertEqual(firstEntity.name, firstMockEntity.name)
                XCTAssertEqual(firstEntity.url, firstMockEntity.url)
                XCTAssertEqual(firstEntity.cacheURL, firstMockEntity.cacheURL)
                
                localSongsExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [localSongsExpectation], timeout: 1.0)
    }
    
    func testGetListLocalSongWithCoreDataError() {
        // Given
        songsStorage.listMock = [.getListSongEntity(.failure(CoreDataStorageError.somethingWentWrong))]
        
        let errorExpectation = XCTestExpectation(description: "Get local songs returns error")
        
        // When
        repository.getListLocalSong(
            completion: { result in
                guard
                    case .failure(let error) = result,
                    let coreDataError = error as? CoreDataStorageError
                else {
                    return
                }
                
                switch coreDataError {
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
    
    func testGetListSongSuccess() {
        // Given
        let dataDTO: DataDTO = loadJSON(filename: "mockSongs", type: DataDTO<[SongDTO]>.self)
        networkService.listMock = [.request(.success(.json("mockSongs")))]
        
        let listSongsExpectation = XCTestExpectation(description: "Get songs from network")
        
        // When
        _ = repository.getListSong(
            completion: { result in
                guard case .success(let songDTOs) = result else {
                    return
                }
                
                let firstMockDTO = dataDTO.data.first!
                let firstDTO = songDTOs.first!
                
                XCTAssertEqual(firstDTO.id, firstMockDTO.id)
                XCTAssertEqual(firstDTO.name, firstMockDTO.name)
                XCTAssertEqual(firstDTO.url, firstMockDTO.url)
                
                listSongsExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [listSongsExpectation], timeout: 1.0)
    }
    
    func testGetListSongWithNetworkError() {
        // Given
        networkService.listMock = [.request(.failure(NetworkError.somethingWentWrong))]
        
        let errorExpectation = XCTestExpectation(description: "Get local songs returns error")
        
        // When
        _ = repository.getListSong(
            completion: { result in
                guard
                    case .failure(let error) = result,
                    let networkError = error as? NetworkError
                else {
                    return
                }
                
                switch networkError {
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
    
    func testDownloadSongSuccess() {
        // Given
        let songDTO = MockSongProvider.provideSongDTOs(numOfItems: 1).first!
        let mockCacheURL = URL(string: "/User/Documents/cache/file.mp3")!
        downloadService.listMock = [.downloadFile(.success(mockCacheURL))]
        
        let progressExpectation = XCTestExpectation(description: "Progress download song")
        let downloadExpectation = XCTestExpectation(description: "Download song")
        
        // When
        _ = repository.downloadSong(
            songDTO,
            progressHandler: { _ in
                progressExpectation.fulfill()
            }, completionHandler: { result in
                guard case .success(let cacheURL) = result else {
                    return
                }
                
                XCTAssertEqual(mockCacheURL.path, cacheURL.path)
                
                downloadExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [downloadExpectation], timeout: 1.0)
    }
    
    func testDownloadSongWithDownloadError() {
        // Given
        let songDTO = MockSongProvider.provideSongDTOs(numOfItems: 1).first!
        downloadService.listMock = [.downloadFile(.failure(DownloadError.somethingWentWrong))]
        
        let errorExpectation = XCTestExpectation(description: "Download song returns error")
        
        // When
        _ = repository.downloadSong(
            songDTO,
            progressHandler: { _ in },
            completionHandler: { result in
                guard
                    case .failure(let error) = result,
                    let downloadError = error as? DownloadError
                else {
                    return
                }
                
                switch downloadError {
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
    
    func testSaveSongToPersistentCache() {
        // Given
        let songDTO = MockSongProvider.provideSongDTOs(numOfItems: 1).first!
        let mockCacheURL = URL(string: "/User/Documents/cache/file.mp3")!
        songsStorage.listMock = [.save(.success(()))]
        
        let saveSongExpectation = XCTestExpectation(description: "Save song to persistent storage")
        
        // When
        repository.saveSongToPersistentStorage(
            songDTO,
            audioCacheURL: mockCacheURL,
            completion: { result in
                guard case .success = result else {
                    return
                }
                
                saveSongExpectation.fulfill()
            }
        )
        
        // Then
        wait(for: [saveSongExpectation], timeout: 1.0)
    }
    
    func testSaveSongToPersistentCacheWithCoreDataError() {
        // Given
        let songDTO = MockSongProvider.provideSongDTOs(numOfItems: 1).first!
        let mockCacheURL = URL(string: "/User/Documents/cache/file.mp3")!
        songsStorage.listMock = [.save(.failure(CoreDataStorageError.somethingWentWrong))]
        
        let errorExpectation = XCTestExpectation(description: "Save song to persistent storage returns error")
        
        // When
        repository.saveSongToPersistentStorage(
            songDTO,
            audioCacheURL: mockCacheURL,
            completion: { result in
                guard
                    case .failure(let error) = result,
                    let coreDataError = error as? CoreDataStorageError
                else {
                    return
                }
                
                switch coreDataError {
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
}

extension SongRepositoryTest {
    private var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    private func loadJSON<T: Decodable>(filename: String, type: T.Type) -> T {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedObject = try JSONDecoder().decode(type, from: data)
            
            return decodedObject
        } catch {
            fatalError("Failed to decode loaded JSON")
        }
    }
}
