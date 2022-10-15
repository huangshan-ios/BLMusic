//
//  DownloadError.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

enum DownloadError: Error {
    case somethingWentWrong
    case invalidURL
    case other(Error)
}
