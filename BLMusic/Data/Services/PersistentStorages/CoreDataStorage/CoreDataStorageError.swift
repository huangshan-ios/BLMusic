//
//  CoreDataStorageError.swift
//  BLMusic
//
//  Created by Son Hoang on 16/10/2022.
//

import Foundation

enum CoreDataStorageError: Error {
    case somethingWentWrong
    case readError(Error)
    case saveError(Error)
    case deleteError(Error)
    case other(Error)
}
