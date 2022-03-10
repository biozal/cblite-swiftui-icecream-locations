//
//  Repository.swift
//  IceCreamLocator
//
//  Created by Aaron LaBeau on 3/8/22.
//

import Foundation
import Combine

protocol Repository {
    associatedtype T
    associatedtype TD
    
    func getListByTypeCityOrderName() -> Void
    func getListByStateGeorgia() -> Void
    func getListByStateGeorgiaFixed() -> Void
}
