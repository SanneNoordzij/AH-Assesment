//
//  CatalogPage.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

struct CatalogResponse: Codable {
    let count: Int
    let artObjects: [ArtObject]
}
