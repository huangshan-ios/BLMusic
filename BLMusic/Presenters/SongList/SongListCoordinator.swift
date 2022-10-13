//
//  SongListCoordinator.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

final class SongListCoordinator: CoordinatorType {
    
    override func start() {
        let viewModel = DependenciesProvider.provideSongListViewModel()
        let coordinator = DependenciesProvider.provideSongListCoordinator()
        let viewController = SongListViewController(viewModel: viewModel,
                                                    coordinator: coordinator,
                                                    controller: SongListViewController.self)
        navigationController.viewControllers = [viewController]
    }
    
}
