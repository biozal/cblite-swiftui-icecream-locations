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
    
    func get(id: String) -> AnyPublisher<TD, Error>
    func getListByCity() -> Void
    func getListSimpleName() -> Void
}
