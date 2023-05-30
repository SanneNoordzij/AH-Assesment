//
//  Coordinator.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

protocol Coordinator {
    var childCoordinator: Coordinator? { get set }
    func start()
}
