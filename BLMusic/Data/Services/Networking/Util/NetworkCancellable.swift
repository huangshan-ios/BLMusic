//
//  NetworkCancellable.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

protocol NetworkCancellable {
    func cancel()
}

extension URLSessionTask: NetworkCancellable { }
