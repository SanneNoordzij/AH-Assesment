//
//  ArtObject.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

struct ArtObject: Codable {
    let id: String
    let objectNumber: String
    let title: String
    let longTitle: String
    let principalOrFirstMaker: String
    let hasImage: Bool
    let showImage: Bool
    let permitDownload: Bool
    let links: ArtObjectLinks
    let webImage: ArtObjectImage?
    let headerImage: ArtObjectImage?
    let productionPlaces: [String]
}

struct ArtObjectLinks: Codable {
    let linksSelf, web: String

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case web
    }
}
