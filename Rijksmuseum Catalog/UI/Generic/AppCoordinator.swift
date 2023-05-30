//
//  AppCoordinator.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import UIKit
import Combine

class AppCoordinator: Coordinator {
    var childCoordinator: Coordinator? = nil

    let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let catalogOverviewCoordinator = CatalogOverviewCoordinator(navigationController: navigationController)
        childCoordinator = catalogOverviewCoordinator
        catalogOverviewCoordinator.start()
    }
}

