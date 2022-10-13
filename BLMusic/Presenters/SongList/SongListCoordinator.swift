//
//  SongListCoordinator.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

final class SongListCoordinator: CoordinatorType {
    
    override func start() {
        let songListViewController = SongListViewController()
        navigationController.viewControllers = [songListViewController]
    }
    
}
