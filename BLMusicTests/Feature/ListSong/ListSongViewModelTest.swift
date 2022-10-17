//
//  ListSongViewModelTest.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import XCTest

@testable import BLMusic

class ListSongViewModelTest: XCTestCase {
    
    private var viewModel: ListSongViewModel!
    private var getListCacheSongUseCase: GetListCacheSongUseCaseMock!
    private var getListSongUseCase: GetListSongUseCaseMock!
    private var playSongUseCase: PlaySongUseCaseMock!
    private var downloadSongUseCase: DownloadSongUseCaseMock!
    
    override func setUp() {
        getListCacheSongUseCase = GetListCacheSongUseCaseMock()
        getListSongUseCase = GetListSongUseCaseMock()
        playSongUseCase = PlaySongUseCaseMock()
        downloadSongUseCase = DownloadSongUseCaseMock()
        
        viewModel = ListSongViewModel(
            getListCacheSongUseCase: getListCacheSongUseCase,
            getListSongUseCase: getListSongUseCase,
            downloadSongUseCase: downloadSongUseCase,
            playSongUseCase: playSongUseCase
        )
    }
    
    override func tearDown() {
        viewModel = nil
        getListCacheSongUseCase = nil
        getListSongUseCase = nil
        playSongUseCase = nil
        downloadSongUseCase = nil
    }
    
}

extension ListSongViewModelTest {
    func testLoadCacheSongSuccess() {
        // Given
        let cacheURL = "/User/Documents/cache/"
        let cacheSongs = MockSongProvider.provideMockCacheSong(numOfItems: 5, cacheURL: cacheURL)
        
        getListCacheSongUseCase.listMock = [.getListCacheSong(.success(cacheSongs))]
        
        let expectation = XCTestExpectation(description: "Loading cache songs")
        
        // When
        viewModel.loadSongsObservable = { [weak self] in
            guard let self = self else {
                return
            }
            
            XCTAssertEqual(self.viewModel.getSongs().count, cacheSongs.count)
            XCTAssertTrue(self.viewModel.getSongs().first!.id.elementsEqual(cacheSongs.first!.id))
            XCTAssertTrue(self.viewModel.getSongs().first!.name.elementsEqual(cacheSongs.first!.name))
            
            expectation.fulfill()
        }
        viewModel.loadSongs()
        
        // Then
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadSongsFromCacheAndThenLoadFromNetWorkSuccess() {
        // Given
        let cacheURL = "/User/Documents/cache/"
        let cacheSongs = MockSongProvider.provideMockCacheSong(numOfItems: 3, cacheURL: cacheURL)
        let responseSongs = MockSongProvider.provideMockSongs(numOfItems: 8)
        
        getListCacheSongUseCase.listMock = [.getListCacheSong(.success(cacheSongs))]
        getListSongUseCase.listMock = [.getListSong(.success(responseSongs))]
        
        let cacheSongsExpectation = XCTestExpectation(description: "Loading cache songs")
        let responseExpectation = XCTestExpectation(description: "Loading response songs")
        let showLoadingExpectation = XCTestExpectation(description: "Show loading")
        let hideLoadingExpectation = XCTestExpectation(description: "Hide loading")
        
        // When
        viewModel.loadSongsObservable = { [weak self] in
            guard let self = self else {
                return
            }
            
            if self.viewModel.getSongs().count == cacheSongs.count {
                XCTAssertEqual(self.viewModel.getSongs().count, cacheSongs.count)
                XCTAssertTrue(self.viewModel.getSongs().first!.id.elementsEqual(cacheSongs.first!.id))
                XCTAssertTrue(self.viewModel.getSongs().first!.name.elementsEqual(cacheSongs.first!.name))
                cacheSongsExpectation.fulfill()
            }
            
            if self.viewModel.getSongs().count == responseSongs.count {
                XCTAssertEqual(self.viewModel.getSongs().count, responseSongs.count)
                XCTAssertTrue(self.viewModel.getSongs().first!.id.elementsEqual(responseSongs.first!.id))
                XCTAssertTrue(self.viewModel.getSongs().first!.name.elementsEqual(responseSongs.first!.name))
                responseExpectation.fulfill()
            }
        }
        
        viewModel.loadingObservable = { isLoading in
            if isLoading {
                showLoadingExpectation.fulfill()
            } else {
                hideLoadingExpectation.fulfill()
            }
        }
        
        viewModel.loadSongs()
        
        // Then
        wait(
            for: [cacheSongsExpectation, responseExpectation,
                  showLoadingExpectation, hideLoadingExpectation],
            timeout: 1.0
        )
        
    }
    
    func testDownloadSongSuccess() {
        // Given
        let responseSongs = MockSongProvider.provideMockSongs(numOfItems: 8)
        let downloadedURL = URL(string: "https/google.com")!
        
        getListCacheSongUseCase.listMock = [.getListCacheSong(.success([]))]
        getListSongUseCase.listMock = [.getListSong(.success(responseSongs))]
        downloadSongUseCase.listMock = [.downloadSong(.success(downloadedURL))]
        
        let progressExpectation = XCTestExpectation(description: "Receive download progress")
        let responseExpectation = XCTestExpectation(description: "Loading response songs")
        
        // When
        viewModel.songStateObservable = { [weak self] index in
            guard let self = self else { return }
            
            let song = self.viewModel.getSongs()[index]
            
            switch song.state {
            case .downloading:
                progressExpectation.fulfill()
            case .ready:
                XCTAssertTrue(downloadedURL.path.elementsEqual(song.cacheURL?.path ?? ""))
                responseExpectation.fulfill()
            default:
                break
            }
            
        }
        viewModel.loadSongs()
        viewModel.downloadSong(at: 0)
        
        // Then
        wait(
            for: [progressExpectation, responseExpectation],
            timeout: 1.0
        )
    }
    
    func testPlaySongSuccess() {
        // Given
        let responseSongs = MockSongProvider.provideMockSongs(numOfItems: 8)
        
        getListCacheSongUseCase.listMock = [.getListCacheSong(.success([]))]
        getListSongUseCase.listMock = [.getListSong(.success(responseSongs))]
        playSongUseCase.listMock = [.play(.success(true))]
        
        let playingExpectation = XCTestExpectation(description: "Playing song")
        
        // When
        viewModel.songStateObservable = { [weak self] index in
            guard let self = self else { return }
            
            let song = self.viewModel.getSongs()[index]
            
            switch song.state {
            case .playing:
                playingExpectation.fulfill()
            default:
                break
            }
            
        }
        viewModel.loadSongs()
        viewModel.playSong(at: 0)
        
        // Then
        wait(for: [playingExpectation], timeout: 1.0)
    }
    
    func testSwitchingPlaying() {
        // Given
        let responseSongs = MockSongProvider.provideMockSongs(numOfItems: 8)
        let switchingIndex = 1
        
        getListCacheSongUseCase.listMock = [.getListCacheSong(.success([]))]
        getListSongUseCase.listMock = [.getListSong(.success(responseSongs))]
        playSongUseCase.listMock = [.play(.success(true))]
        
        let playingExpectation = XCTestExpectation(description: "Playing song")
        
        // When
        viewModel.songStateObservable = { index in
            if index == switchingIndex {
                playingExpectation.fulfill()
            }
        }
        viewModel.loadSongs()
        viewModel.playSong(at: 0)
        viewModel.playSong(at: switchingIndex)
        
        // Then
        wait(for: [playingExpectation], timeout: 1.0)
    }
    
    func testStopPlaying() {
        // Given
        let responseSongs = MockSongProvider.provideMockSongs(numOfItems: 8)
        
        getListCacheSongUseCase.listMock = [.getListCacheSong(.success([]))]
        getListSongUseCase.listMock = [.getListSong(.success(responseSongs))]
        playSongUseCase.listMock = [.play(.success(true)), .stop(.success(false))]
        
        let stopPlayingExpectation = XCTestExpectation(description: "Stop playing song")
        
        // When
        viewModel.songStateObservable = { [weak self] index in
            guard let self = self else { return }
            
            let song = self.viewModel.getSongs()[index]
            
            switch song.state {
            case .ready:
                stopPlayingExpectation.fulfill()
            default:
                break
            }
            
        }
        viewModel.loadSongs()
        viewModel.playSong(at: 0)
        viewModel.stopPlay(at: 0)
        
        // Then
        wait(for: [stopPlayingExpectation], timeout: 1.0)
    }
}
