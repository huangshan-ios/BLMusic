//
//  AppError.swift
//  BLMusic
//
//  Created by Son Hoang on 15/10/2022.
//

import Foundation

struct CommonUIError: Error {
    let id: Int
    let message: String
    
    static let somethingWhenWrong: CommonUIError = CommonUIError(id: 0, message: "Something went wrong")
}
