//
//  AppConstants.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

struct AppConstants {
    static var baseURL: String {
        let urlString = AppConfigurationHelper.shared.value(for: "SERVER_BASE_URL") ?? ""
        return urlString
    }
        
    struct URL {
        static let songs = "Songs.json"
    }
    
    struct Document {
        static var cacheDirectoryURL: Foundation.URL {
            let documentsUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return documentsUrl.appendingPathComponent("cache")
        }
    }
}
