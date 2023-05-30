//
//  CatalogRepositoryTests.swift
//  Rijksmuseum CatalogTests
//
//  Created by Sanne Noordzij on 30/05/2023.
//

import XCTest
@testable import Rijksmuseum_Catalog

final class CatalogRepositoryTests: XCTestCase {
    
    func testOverviewPage() async throws {
        let repo = CatalogRepository(catalogAPI: SampleCatalogAPIProtocolMock())
        let page = try await repo.getCatalogPage(pageNumber: 1)
        assert(page.count == 10)
    }
    
    func testItemDetails() async throws {
        let repo = CatalogRepository(catalogAPI: SampleCatalogAPIProtocolMock())
        let details = try await repo.getDetails(forCatalogItem: CatalogItem(id: "nl-SK-C-5", title: "", imageURL: nil))
        assert(details.title == "De Nachtwacht")
    }
}

