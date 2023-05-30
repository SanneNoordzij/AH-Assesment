//
//  ArtObjectDetailCoordinator.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import Combine
import UIKit

class ArtObjectDetailCoordinator: Coordinator {
    var childCoordinator: Coordinator? = nil

    private let navigationController: UINavigationController
    private let viewModel: ArtObjectDetailViewModel
    private var cancellables = Set<AnyCancellable>()
    private var parent: Coordinator

    init(parent: Coordinator, navigationController: UINavigationController, item: CatalogItem) {
        self.navigationController = navigationController
        self.parent = parent
        viewModel = ArtObjectDetailViewModel(item: item)
    }

    func start() {
        let viewController = ArtObjectDetailViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
        bind()
    }

    private func bind() {
        viewModel.navigationEvent
            .sink { [weak self] event in
                switch event {
                case .dismiss:
                    self?.navigationController.popViewController(animated: true)
                }
                self?.parent.childCoordinator = nil
            }
            .store(in: &cancellables)
    }
}
