//
//  NetworkRequest.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

enum HTTPMethod: String {
    case GET, POST, PUT, DELETE
}

protocol NetworkRequest {
    
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: String]? { get }
    
    func makeRequest() throws -> URLRequest
    
}

extension NetworkRequest {
    func makeRequest() throws -> URLRequest {
        var request = URLRequest(url: url)
        
        request.httpMethod = method.rawValue
        
        if let headers = headers {
            for header in headers {
                request.addValue(header.key, forHTTPHeaderField: header.value)
            }
        }
        
        if let parameters = parameters {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                request.httpBody = jsonData
            } catch let error {
                throw error
            }
        }
        
        return request
    }
}
