//
//  CatalogRepository.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

protocol CatalogRepositoryProtocol {
    func getCatalogPage(pageNumber: Int) async throws -> [CatalogItem]
    func getDetails(forCatalogItem item: CatalogItem) async throws -> CatalogItemDetails
}

struct CatalogRepository: CatalogRepositoryProtocol {

    private let catalogAPI: CatalogAPIProtocol

    init(catalogAPI: CatalogAPIProtocol = CatalogAPI()) {
        self.catalogAPI = catalogAPI
    }

    func getCatalogPage(pageNumber: Int) async throws -> [CatalogItem] {
        let artObjects = try await catalogAPI.getCatalog(pageNumber: pageNumber).artObjects
        return artObjects.map {
            CatalogItem(
                id: $0.objectNumber,
                title: $0.title,
                imageURL: URL(string: $0.webImage?.url ?? "")
            )
        }
    }
    
    func getDetails(forCatalogItem item: CatalogItem) async throws -> CatalogItemDetails {
        let artObject = try await catalogAPI.getDetails(objectId: item.id).artObject
        return CatalogItemDetails(
            title: artObject.label.title,
            maker: artObject.principalMaker,
            description: artObject.label.description,
            imageURL: URL(string: artObject.webImage?.url ?? "")
        )
    }

}
