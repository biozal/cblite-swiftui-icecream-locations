//
//  IceCream.swift
//  IceCreamLocator
//
//  Created by Aaron LaBeau on 3/8/22.
//

import Foundation

// MARK: - Ice Cream Location
struct Location: Codable, Identifiable {
    let geometry: Geometry
    let id: String
    let properties: Properties
    let type: String
}

struct IceCreamLocation : Codable, Identifiable {
    let id: String
    let name: String
    let addrCity, addrHousenumber, addrPostcode, addrState, addrStreet: String?
}

// MARK: - Geometry
struct Geometry: Codable {
    let coordinates: [Double]
    let type: String
}

// MARK: - Properties
struct Properties: Codable {
    let addrCity, addrHousenumber, addrPostcode, addrState: String
    let addrStreet, amenity, dataset, dcgisLot: String
    let dcgisSquare, id, name, source: String

    enum CodingKeys: String, CodingKey {
        case addrCity = "addr:city"
        case addrHousenumber = "addr:housenumber"
        case addrPostcode = "addr:postcode"
        case addrState = "addr:state"
        case addrStreet = "addr:street"
        case amenity, dataset
        case dcgisLot = "dcgis:lot"
        case dcgisSquare = "dcgis:square"
        case id, name, source
    }
}
