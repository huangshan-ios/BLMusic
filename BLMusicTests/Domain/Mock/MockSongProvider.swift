//
//  MockSongProvider.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//

import Foundation

@testable import BLMusic

class MockSongProvider {
    class func provideMockCacheSong(numOfItems: Int, cacheURL: String) -> [Song] {
        return (0...numOfItems).map { index in
            return Song(id: "\(index)",
                        name: "Cache Song \(index)",
                        url: "https://google.com/Song\(index)",
                        state: .ready,
                        cacheURL: URL(string: "\(cacheURL)/Song_\(index)")
            )
        }
    }
    
    class func provideMockSongs(numOfItems: Int) -> [Song] {
        return (0...numOfItems).map { index in
            return Song(id: "\(index)",
                        name: "Response Song \(index)",
                        url: "https://google.com/Song\(index)"
            )
        }
    }
}
