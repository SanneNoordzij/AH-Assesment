//
//  ArtObjectImage.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

struct ArtObjectImage: Codable {
    let guid: String?
    let offsetPercentageX: Int
    let offsetPercentageY: Int
    let width: Int
    let height: Int
    let url: String?
}
