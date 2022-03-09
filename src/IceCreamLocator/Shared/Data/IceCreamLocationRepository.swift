//
//  IceCreamLocationRepository.swift
//  IceCreamLocator
//
//  Created by Aaron LaBeau on 3/8/22.
//

import Foundation
import Combine
import CouchbaseLiteSwift

class IceCreamLocationRepository: Repository {
    typealias T = IceCreamLocation
    typealias TD = Location
    
    enum DbError : LocalizedError {
        case nilDatabase
        case nilDocument
        case unknown
    }
    
    // db name
    fileprivate let _dbName: String = "icecream"
    fileprivate let _prebuildFolder = "prebuilt"
    
    fileprivate var _db:Database?
    fileprivate var _applicationDocumentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last
    fileprivate var _applicationSupportDirectory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).last
    
    init() {
        Database.log.console.domains = .all
        //this will log EVERYTHING - it's a lot of information to go through
        Database.log.console.level = .verbose
        
        //open the database for use
        openPrebuitDatabase()
    }
    
    deinit {
        // Stop observing changes to the database that affect the query
        do {
            try self._db?.close()
            self._db = nil
        }
        catch  {
        }
    }
    
    fileprivate func openPrebuitDatabase() {
        do {
            var options = DatabaseConfiguration()
            guard let icecreamFolderUrl = _applicationSupportDirectory else {
                fatalError("Could not open Application Support Directory for app!")
            }
            let icecreamFolderPath = icecreamFolderUrl.path
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: icecreamFolderPath) {
                try fileManager.createDirectory(atPath: icecreamFolderPath,
                                                withIntermediateDirectories: true,
                                                attributes: nil)
            }
            //set the folder path for the CBLite DB
            options.directory = icecreamFolderPath
            
            //load the prebuilt "icecream" database if it does not exist at the specified folder
            if Database.exists(withName: _dbName, inDirectory: icecreamFolderPath) == false {
                //load prebuild database from app bundle and copy over to applications support path - must use Database.copy
                if let prebuiltPath = Bundle.main.path(forResource: _dbName, ofType: "cblite2") {
                    try Database.copy(fromPath: prebuiltPath, toDatabase: "\(_dbName)", withConfig: options)
                }
                //get handle to db
                _db = try Database(name: _dbName, config: options)
                
                try createIceCreamIndexes()
            }
            else {
                _db = try Database(name: _dbName, config: options)
            }
        } catch {
            fatalError("Closing because of error: \(error)")
        }
    }
    
    fileprivate func createIceCreamIndexes() throws {
        
    }
    
    func get(id: String) -> AnyPublisher<Location, Error> {
        let subject = PassthroughSubject<Location, Error>()
        do {
            //valiate we have a database connection and it's open
            if let doc = _db?.document(withID: id) {
                if let data = doc.toJSON().data(using: .utf8) {
                    let location = try JSONDecoder().decode(Location.self, from: data)
                    subject.send(location)
                    subject.send(completion: .finished)
                    return subject.eraseToAnyPublisher()
                }
            }
        } catch {
            subject.send(completion: .failure(DbError.nilDocument))
        }
        
        subject.send(completion: .failure(DbError.nilDatabase))
        return subject.eraseToAnyPublisher()
    }
    
    func list() -> AnyPublisher<[IceCreamLocation], Error> {
        let subject = PassthroughSubject<[IceCreamLocation], Error>()
        //todo get list of icecream locations
        
        return subject.eraseToAnyPublisher()
    }
    
    func add(_ document: Location, id: String) -> AnyPublisher<Void, Error> {
        let subject = PassthroughSubject<Void, Error>()
        return subject.eraseToAnyPublisher()
        
    }
    
    func edit(_ document: Location) -> AnyPublisher<Void, Error> {
        let subject = PassthroughSubject<Void, Error>()
        return subject.eraseToAnyPublisher()
        
    }
    
    func delete(_ id: String) -> AnyPublisher<Void, Error> {
        let subject = PassthroughSubject<Void, Error>()
        return subject.eraseToAnyPublisher()
    }
    
    
    
}
