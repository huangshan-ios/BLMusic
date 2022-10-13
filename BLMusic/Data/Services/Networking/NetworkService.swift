//
//  NetworkService.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

protocol NetworkSevice {
    func request<T: Decodable>(
        _ request: NetworkRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> NetworkCancellable?
}

final class NetworkServiceImpl: NetworkSevice {
    func request<T: Decodable>(
        _ request: NetworkRequest,
        completion: @escaping (Result<T, Error>) -> Void
    ) -> NetworkCancellable? {
        var cancellable: NetworkCancellable?
        do {
            let urlRequest = try request.makeRequest()
            let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                
                if let error = error {
                    switch error {
                    case let errorResponse as URLError:
                        completion(.failure(NetworkError.invalidResponse(errorResponse)))
                    default:
                        completion(.failure(NetworkError.other(error)))
                    }
                    return
                }
                
                if let data = data {
                    do {
                        let dtoResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(dtoResponse))
                    } catch {
                        completion(.failure(NetworkError.invalidJSON))
                    }
                    return
                }
                
                completion(.failure(NetworkError.somethingWentWrong))
                
            }
            task.resume()
            cancellable = task
        } catch let error {
            completion(.failure(NetworkError.invalidRequest(error)))
        }
        
        return cancellable
    }
}
