//
//  JSONMockReader.swift
//  Rijksmuseum CatalogTests
//
//  Created by Sanne Noordzij on 30/05/2023.
//

import Foundation

class JSONMockReader {
    static func fetchMock(fileName: String) -> Data? {
        let bundle = Bundle(for: JSONMockReader.self)
        guard let path = bundle.path(forResource: fileName, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            return nil
        }
        return data
    }
}
