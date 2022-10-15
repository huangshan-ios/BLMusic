//
//  DownloadCancellable.swift
//  BLMusic
//
//  Created by Son Hoang on 14/10/2022.
//

import Foundation

protocol DownloadCancellable: Cancellable {
}

extension Operation: DownloadCancellable { }
