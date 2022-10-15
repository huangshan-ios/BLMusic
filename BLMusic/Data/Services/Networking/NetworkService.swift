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
        var task: URLSessionTask?
        
        do {
            let urlRequest = try request.makeRequest()
            
            task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                
                if let error = error {
                    switch error {
                    case let errorResponse as URLError:
                        completion(.failure(NetworkError.invalidResponse(errorResponse)))
                    default:
                        completion(.failure(NetworkError.other(error)))
                    }
                } else if let data = data {
                    do {
                        let dtoResponse = try JSONDecoder().decode(T.self, from: data)
                        completion(.success(dtoResponse))
                    } catch {
                        completion(.failure(NetworkError.invalidJSON))
                    }
                } else {
                    completion(.failure(NetworkError.somethingWentWrong))
                }
            }
            
            task?.resume()
            
        } catch let error {
            completion(.failure(NetworkError.invalidRequest(error)))
            return nil
        }
            
        return task
    }
}
