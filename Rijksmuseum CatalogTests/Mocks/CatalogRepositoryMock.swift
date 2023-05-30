//
//  CatalogRepositoryMock.swift
//  Rijksmuseum CatalogTests
//
//  Created by Sanne Noordzij on 30/05/2023.
//

import Foundation
@testable import Rijksmuseum_Catalog

class ErrorCatalogRepositoryProtocolMock: CatalogRepositoryProtocol {
    enum MockError: Error {
        case mockError
    }
    func getCatalogPage(pageNumber: Int) async throws -> [CatalogItem] {
        throw MockError.mockError
    }
    func getDetails(forCatalogItem item: CatalogItem) async throws -> CatalogItemDetails {
        throw MockError.mockError
    }
}

class SampleCatalogRepositoryProtocolMock: CatalogRepositoryProtocol {
    
    func getDetails(forCatalogItem item: CatalogItem) async throws -> CatalogItemDetails {
        guard let data = JSONMockReader.fetchMock(fileName: "CatalogDetailResponse") else { fatalError("Unable to find mock") }
        do {
            let catalogDetailResponse: CatalogDetailResponse = try JSONDecoder().decode(CatalogDetailResponse.self, from: data)
            let artObject = catalogDetailResponse.artObject
            return CatalogItemDetails(
                title: artObject.label.title,
                maker: artObject.principalMaker,
                description: artObject.label.description,
                imageURL: URL(string: artObject.webImage?.url ?? "")
            )
        } catch {
            fatalError("Unable to decode mock")
        }
    }
    
    func getCatalogPage(pageNumber: Int) async throws -> [CatalogItem] {
        guard let data = JSONMockReader.fetchMock(fileName: "CatalogResponse") else { fatalError("Unable to find mock") }
        do {
            let catalogResponse: CatalogResponse = try JSONDecoder().decode(CatalogResponse.self, from: data)
            return catalogResponse.artObjects.map {
                CatalogItem(
                    id: $0.objectNumber,
                    title: $0.title,
                    imageURL: URL(string: $0.webImage?.url ?? "")
                )
            }
        } catch {
            fatalError("Unable to decode mock")
        }
    }
}
