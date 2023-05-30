//
//  ArtObjectDetailViewModel.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import Combine

class ArtObjectDetailViewModel {
    enum NavigationDestination {
        case dismiss
    }
    
    enum State {
        case loading
        case error
        case data(CatalogItemDetails)
    }

    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    private let stateSubject = CurrentValueSubject<State, Never>(.loading)
    let navigationEvent = PassthroughSubject<NavigationDestination, Never>()

    private let item: CatalogItem
    private let catalogRepository: CatalogRepositoryProtocol

    init(item: CatalogItem, catalogRepository: CatalogRepositoryProtocol = CatalogRepository()) {
        self.item = item
        self.catalogRepository = catalogRepository
        fetchDetails()
    }
    
    func fetchDetails() {
        stateSubject.send(.loading)
        Task.init {
            do {
                let details = try await catalogRepository.getDetails(forCatalogItem: self.item)
                self.stateSubject.send(.data(details))
            } catch {
                print(error)
                stateSubject.send(.error)
            }
        }
    }

    func viewDidDisappear() {
        navigationEvent.send(.dismiss)
    }
}

