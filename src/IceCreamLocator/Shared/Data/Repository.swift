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
    func getList() -> Void
    func add(_ document: TD, id: String) -> AnyPublisher<Void, Error>
    func edit(_ document: TD) -> AnyPublisher<Void, Error>
    func delete(_ id: String) -> AnyPublisher<Void, Error>
}
