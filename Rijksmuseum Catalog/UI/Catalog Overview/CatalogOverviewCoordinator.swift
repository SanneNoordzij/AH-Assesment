//
//  CatalogOverviewCoordinator.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import UIKit
import Combine

class CatalogOverviewCoordinator: Coordinator {

    var childCoordinator: Coordinator? = nil {
        didSet {
            if childCoordinator == nil {
                childCoordinatorCancellables = Set<AnyCancellable>()
            }
        }
    }
    private let viewModel = CatalogOverviewViewModel()
    private let navigationController: UINavigationController
    private var cancellables = Set<AnyCancellable>()
    private var childCoordinatorCancellables = Set<AnyCancellable>()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let catalogOverviewViewController = CatalogOverviewViewController(viewModel: viewModel)
        bind()
        navigationController.pushViewController(catalogOverviewViewController, animated: !navigationController.viewControllers.isEmpty)
    }

    private func bind() {
        viewModel.navigationEvent
            .eraseToAnyPublisher()
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] navigationDestination in
                switch navigationDestination {
                case .showCatalogDetail(let item):
                    self?.showDetails(forCatalogItem: item)
                }
            }
            .store(in: &cancellables)
    }

    private func showDetails(forCatalogItem item: CatalogItem) {
        let artObjectDetailCoordinator = ArtObjectDetailCoordinator(parent: self, navigationController: navigationController, item: item)
        childCoordinator = artObjectDetailCoordinator
        artObjectDetailCoordinator.start()
    }
}

