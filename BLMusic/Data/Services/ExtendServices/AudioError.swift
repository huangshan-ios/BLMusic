//
//  AudioError.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

enum AudioError: Error {
    case invalidURL
    case somethingWentWrong
    case other(Error)
}
