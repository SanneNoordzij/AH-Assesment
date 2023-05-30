//
//  Rijksmuseum_CatalogTests.swift
//  Rijksmuseum CatalogTests
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import XCTest
@testable import Rijksmuseum_Catalog

final class CatalogOverviewViewModelTests: XCTestCase {

    let sampleMock = SampleCatalogRepositoryProtocolMock()
    
    func testError() throws {
        let viewModel = CatalogOverviewViewModel(catalogRepository: ErrorCatalogRepositoryProtocolMock())
        
        let errorState = viewModel.statePublisher.filter({ state -> Bool in
            guard case CatalogOverviewViewModel.State.error = state else { return false }
            return true
        })
        
        let result = try awaitPublisher(errorState)
        
        guard case CatalogOverviewViewModel.State.error = result else {
            fatalError("Excpected error state")
        }
    }

    func testStandardReviewLoading() throws {
        let viewModel = CatalogOverviewViewModel(catalogRepository: sampleMock)
        
        
        let dataState = viewModel.statePublisher.filter({ state -> Bool in
            guard case CatalogOverviewViewModel.State.data = state else { return false }
            return true
        })
        let result = try awaitPublisher(dataState)
        
        guard case let CatalogOverviewViewModel.State.data(data) = result else {
            fatalError("expected data object")
        }
        
        assert(data.currentItems.count == 1)
        assert(data.currentItems[1]?.count == 10)
    }
}
