//
//  CatalogAPIMock.swift
//  Rijksmuseum CatalogTests
//
//  Created by Sanne Noordzij on 30/05/2023.
//

import Foundation
@testable import Rijksmuseum_Catalog

class SampleCatalogAPIProtocolMock: CatalogAPIProtocol {
    
    func getDetails(objectId: String) async throws -> CatalogDetailResponse {
        guard let data = JSONMockReader.fetchMock(fileName: "CatalogDetailResponse") else { fatalError("Unable to find mock") }
        do {
            let catalogDetailResponse: CatalogDetailResponse = try JSONDecoder().decode(CatalogDetailResponse.self, from: data)
            return catalogDetailResponse
        } catch {
            fatalError("Unable to decode mock")
        }
    }
    
    func getCatalog(pageNumber: Int) async throws -> CatalogResponse {
        guard let data = JSONMockReader.fetchMock(fileName: "CatalogResponse") else { fatalError("Unable to find mock") }
        do {
            let catalogResponse: CatalogResponse = try JSONDecoder().decode(CatalogResponse.self, from: data)
            return catalogResponse
        } catch {
            fatalError("Unable to decode mock")
        }
    }
}
