//
//  ErrorTypeMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

enum ErrorTypeMock: Error {
    case json(String)
    case error(Error)
}
