//
//  RepositoryTask.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var downloadTask: DownloadCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        downloadTask?.cancel()
        isCancelled = true
    }
}
