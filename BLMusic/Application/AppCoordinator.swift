//
//  AppCoordinator.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

final class AppCoordinator: CoordinatorType {
    var window: UIWindow?
    
    init(window: UIWindow?) {
        self.window = window
    }
    
    override func start() {
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        let collectionsCoordinator = SongListCoordinator()
        collectionsCoordinator.navigationController = navigationController
        start(collectionsCoordinator)
    }
}
