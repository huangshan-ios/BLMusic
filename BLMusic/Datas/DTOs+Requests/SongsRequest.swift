//
//  SongsRequest.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

struct SongsRequest: NetworkRequest {
    var url: URL {
        return URL(string: AppConstants.baseURL + AppConstants.URL.songs)!
    }
    
    var method: HTTPMethod {
        return .GET
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    var parameters: [String : String]? {
        return nil
    }
}
