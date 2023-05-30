//
//  CatalogDetailResponse.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

struct CatalogDetailResponse: Codable {
    let elapsedMilliseconds: Int
    let artObject: ArtObjectDetails
}
