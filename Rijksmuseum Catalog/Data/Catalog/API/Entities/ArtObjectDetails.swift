//
//  ArtObjectDetails.swift
//  Rijksmuseum Catalog
//
//  Created by Sanne Noordzij on 29/05/2023.
//

import Foundation

struct ArtObjectDetails: Codable {
    let links: ArtObjectDetailLinks
    let title: String
    let webImage: ArtObjectImage?
    let titles: [String]
    let description: String
    let labelText: String?
    let plaqueDescriptionDutch: String?
    let principalMaker: String
    let hasImage: Bool
    let historicalPersons: [String]
    let documentation: [String]
    let label: Label
    let showImage: Bool
    let location: String
}

struct Label: Codable {
    let title: String
    let makerLine: String
    let description: String
    let notes: String?
    let date: String
}

struct ArtObjectDetailLinks: Codable {
    let search: String
}
