//
//  RepositoryTask.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

class RepositoryTask: Cancellable {
    var serviceTask: Cancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        serviceTask?.cancel()
        isCancelled = true
    }
}
