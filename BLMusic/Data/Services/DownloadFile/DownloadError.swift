//
//  DownloadError.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

enum DownloadError: Error {
    case fileExist
    case invalidURL
    case somethingWentWrong    
    case other(Error)
}
