//
//  SongsStorage.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation
import CoreData

protocol SongsStorage {
    var coreDataStorage: CoreDataStorage { get }
    
    func getListSongEntity(completion: @escaping (Result<[SongEntity], Error>) -> Void)
    func save(
        _ dto: SongDTO,
        cacheURL: URL?,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class SongsStorageImpl: SongsStorage {
    let coreDataStorage: CoreDataStorage
    
    init(coreDataStorage: CoreDataStorage = CoreDataStorage.shared) {
        self.coreDataStorage = coreDataStorage
    }
    
    func getListSongEntity(completion: @escaping (Result<[SongEntity], Error>) -> Void) {
        coreDataStorage.performBackgroundTask { context in
            do {
                let fetchRequest = SongEntity.fetchRequest()
                let requestEntity = try context.fetch(fetchRequest)
                
                completion(.success(requestEntity))
            } catch {
                completion(.failure(CoreDataStorageError.readError(error)))
            }
        }
    }
    
    func save(
        _ dto: SongDTO,
        cacheURL: URL?,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        coreDataStorage.performBackgroundTask { context in
            let request: NSFetchRequest = SongEntity.fetchRequest()
            request.predicate = NSPredicate(format: "%K = %@", (\SongEntity.id)._kvcKeyPathString!, dto.id)
            do {
                let requestEntity = try context.fetch(request).first
                if !dto.id.elementsEqual(requestEntity?.id ?? "") {
                    let entity: SongEntity = .init(context: context)
                    entity.id = dto.id
                    entity.name = dto.name
                    entity.url = dto.url
                    entity.cacheURL = cacheURL
                    
                    try context.save()
                    
                }
                completion(.success(()))
            } catch let error {
                completion(.failure(CoreDataStorageError.saveError(error)))
            }
        }
    }
}
