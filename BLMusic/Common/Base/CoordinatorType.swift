//
//  Coordinator.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

protocol Coordinator: AnyObject {

    var navigationController: UINavigationController { get set }
    var parentCoordinator: CoordinatorType? { get set }
    var dependency
    
    func start()
    func start(_ coordinator: CoordinatorType)
    func finish(_ coordinator: CoordinatorType)
    
}

class CoordinatorType: Coordinator {
 
    var navigationController = UINavigationController()
    var parentCoordinator: CoordinatorType?
    var childCoordinators: [CoordinatorType] = []
    
    func start() {
        fatalError("Start method must be implemented")
    }
    
    func start(_ coordinator: CoordinatorType) {
        self.childCoordinators.append(coordinator)
        coordinator.parentCoordinator = self
        coordinator.start()
    }
    
    func finish(_ coordinator: CoordinatorType) {
        if let index = self.childCoordinators.firstIndex(where: { $0 === coordinator }) {
            self.childCoordinators.remove(at: index)
        }
    }

}
