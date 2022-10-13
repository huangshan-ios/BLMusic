//
//  ViewControllerType.swift
//  BLMusic
//
//  Created by Son Hoang on 13/10/2022.
//

import UIKit

class ViewControllerType<ViewModel: ViewModelType, Coordinator: CoordinatorType>: UIViewController {
    
    var viewModel: ViewModel!
    weak var coordinator: Coordinator!
    
    init(
        viewModel: ViewModel,
        coordinator: Coordinator,
        controller: ViewControllerType.Type
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: controller.className, bundle: Bundle(for: controller))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupBindings()
    }
    
    func setupViews() {}
    func setupBindings() {}
    
    func handleError(error: Error) {
        showError(error: error)
    }
    
    func showIndicator(_ isLoading: Bool) {
        if isLoading {
            IndicatorLoader.shared.show()
        } else {
            IndicatorLoader.shared.hide()
        }
    }
    
}

extension ViewControllerType {
    private func showError(error: Error) {
    }
}
