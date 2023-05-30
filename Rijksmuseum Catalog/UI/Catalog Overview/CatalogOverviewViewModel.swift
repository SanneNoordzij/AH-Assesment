//
//  CatalogOverviewViewModel.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation
import Combine

class CatalogOverviewViewModel {
    
    enum NavigationDestination {
        case showCatalogDetail(CatalogItem)
    }

    enum State {
        case loading
        case error
        case data(CatalogOverviewViewModelData)
    }

    var statePublisher: AnyPublisher<State, Never> {
        stateSubject.eraseToAnyPublisher()
    }

    private let stateSubject = CurrentValueSubject<State, Never>(.loading)
    let navigationEvent = PassthroughSubject<NavigationDestination, Never>()

    private let catalogRepository: CatalogRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var currentPage = 1
    private var currentListOfItems: [Int:[CatalogItem]] = [:]

    init(catalogRepository: CatalogRepositoryProtocol = CatalogRepository()) {
        self.catalogRepository = catalogRepository
        fetchCatalogItems()
    }

    func fetchCatalogItems(forPage: Int? = nil) {
        stateSubject.send(.loading)
        Task.init {
            do {
                let catalogItems = try await catalogRepository.getCatalogPage(pageNumber: forPage ?? currentPage)
                self.currentListOfItems[forPage ?? currentPage] = catalogItems
                self.stateSubject.send(.data(CatalogOverviewViewModelData(currentItems: currentListOfItems, reachedEndOfList: catalogItems.isEmpty)))
            } catch {
                print(error)
                stateSubject.send(.error)
            }
        }
    }
    
    func fetchNextSetOfItems() {
        if case State.loading = stateSubject.value { return }
        currentPage += 1
        fetchCatalogItems(forPage: currentPage)
    }

    func didSelect(item: CatalogItem?) {
        guard let item = item else { return }
        navigationEvent.send(.showCatalogDetail(item))
    }

}

struct CatalogOverviewViewModelData {
    let currentItems: [Int:[CatalogItem]]
    let reachedEndOfList: Bool
}
