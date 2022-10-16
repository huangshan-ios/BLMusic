//
//  ListSongCoordinator.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import Foundation

final class ListSongCoordinator: CoordinatorType {
    
    override func start() {
        let viewModel = DependenciesProvider.provideListSongViewModel()
        let coordinator = DependenciesProvider.provideListSongCoordinator()
        let viewController = ListSongViewController(viewModel: viewModel,
                                                    coordinator: coordinator,
                                                    controller: ListSongViewController.self)
        navigationController.viewControllers = [viewController]
    }
    
}
