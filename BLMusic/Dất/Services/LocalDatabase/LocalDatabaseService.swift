//
//  LocalDatabaseService.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol LocalDatabaseService {
    func store<T: Codable>(_ data: T)
    func object<T: Codable>() -> T?
}

final class LocalDatabaseServiceImpl: LocalDatabaseService {
    func store<T>(_ data: T) where T : Codable {
    }
    
    func object<T>() -> T? where T : Codable {
        return nil
    }
}
