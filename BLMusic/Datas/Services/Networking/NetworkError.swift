//
//  NetworkError.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

enum NetworkError: Error {
    case somethingWentWrong
    case invalidRequest(Error)
    case invalidResponse(Error)
    case invalidJSON
    case other(Error)
}
