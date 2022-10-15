//
//  FileStorageError.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

enum FileStorageError: Error {
    case fileExist
    case somethingWentWrong
    case other(Error)
}
