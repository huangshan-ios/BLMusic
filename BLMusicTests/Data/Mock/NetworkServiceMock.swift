//
//  NetworkServiceMock.swift
//  BLMusicTests
//
//  Created by Son Hoang on 17/10/2022.
//


import Foundation

@testable import BLMusic

final class NetworkServiceMock: NetworkService, Mockable {
    var listMock: [MockType] = []
    
    enum MockType {
        case request(Result<DataTypeMock, Error>)
        
        enum Case {
            case request
        }
        
        var `case`: Case {
            switch self {
            case .request: return .request
            }
        }
    }
    
    func request<T>(_ request: NetworkRequest, completion: @escaping (Result<T, Error>) -> Void) -> NetworkCancellable? where T : Decodable {
        guard let mock = listMock.first(where: { $0.case == .request }) else {
            return nil
        }
        
        switch mock {
        case .request(let result):
            switch result {
            case .success(let dataMock):
                switch dataMock {
                case .json(let fileName):
                    let response = loadJSON(filename: fileName, type: T.self)
                    completion(.success(response))
                case .object(let response):
                    completion(.success(response as! T))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        return nil
    }
}
