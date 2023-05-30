//
//  CatalogAPI.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

protocol CatalogAPIProtocol {
    func getCatalog(pageNumber: Int) async throws -> CatalogResponse
    func getDetails(objectId: String) async throws -> CatalogDetailResponse
}

struct CatalogAPI: CatalogAPIProtocol {

    enum ReviewAPIError: Error {
        case urlNotFound
    }
    
    private let baseURL = "https://www.rijksmuseum.nl/api/nl/collection"
    
    func getCatalog(pageNumber: Int) async throws -> CatalogResponse {
        guard let url = createURL(forPageNumber: pageNumber) else {
            assertionFailure("URL not found in review for review API")
            throw ReviewAPIError.urlNotFound
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(CatalogResponse.self, from: data)
    }
    
    func getDetails(objectId: String) async throws -> CatalogDetailResponse {
        guard let url = createURL(forObjectId: objectId) else {
            assertionFailure("URL not found in review for review API")
            throw ReviewAPIError.urlNotFound
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(CatalogDetailResponse.self, from: data)
    }
    
    private func createURL(forPageNumber pageNumber: Int) -> URL? {
        return URL(string:"\(baseURL)?key=0fiuZFh4&ps=10&p=\(pageNumber)")
    }
    
    private func createURL(forObjectId objectId: String) -> URL? {
        return URL(string:"\(baseURL)/\(objectId)/?key=0fiuZFh4")
    }
}
