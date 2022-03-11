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
    
    var iceCreamLocationList = CurrentValueSubject<[IceCreamLocation], Error>([])
    
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
            }
            else {
                _db = try Database(name: _dbName, config: options)
            }
            try createIceCreamIndexes()
        } catch {
            print (error)
            fatalError("Closing because of error: \(error)")
        }
    }
    
    fileprivate func createIceCreamIndexes() throws {
        
        //create first query index
        try _db?.deleteIndex(forName: "idx_location_type_city_name")
        let simpleIndex = ValueIndexConfiguration(["properties.name","properties.addrCity","type"])
        try _db?.createIndex(simpleIndex, name: "idx_location_type_city_name")
        
        //create second query index
        try _db?.deleteIndex(forName: "idx_location_type_city_state_name")
        let secondIndex = ValueIndexConfiguration(["properties.name","properties.addrCity","type","properties.addrState"])
        try _db?.createIndex(secondIndex, name: "idx_location_type_city_state_name")
        
        //create third query index
        //let simpleIndex = ValueIndexConfiguration(["name"])
        //try _db?.createIndex(simpleIndex, name: "idx_location_name")
    }
    
    func getListByTypeCityOrderName() -> Void {
        do {
            if let query = try _db?.createQuery("SELECT id, properties.addrCity, properties.addrHousenumber, properties.addrPostcode, properties.addrStreet, properties.addrState, properties.name FROM _ WHERE properties.addrCity <> \"\" AND type = \"Feature\" ORDER BY properties.name") {
                var results: [IceCreamLocation] = []
                let explain = try query.explain()
                print ("**EXPLAIN** \(explain)")
                for result in try query.execute() {
                    if let data = result.toJSON().data(using: .utf8){
                        let location = try JSONDecoder().decode(IceCreamLocation.self, from: data)
                        results.append(location)
                    }
                }
                self.iceCreamLocationList.send(results)
                self.iceCreamLocationList.send(completion: .finished)
            }
        } catch {
            print("**Error**: \(error)")
            self.iceCreamLocationList.send(completion: .failure(DbError.unknown))
        }
    }
    
    func getListByStateGeorgia() -> Void {
        do {
            if let query = try _db?.createQuery("SELECT id, properties.addrCity, properties.addrHousenumber, properties.addrPostcode, properties.addrStreet, properties.addrState, properties.name FROM _ WHERE  properties.addrCity NOT NULL AND properties.addrState = \"GA\" AND type=\"Feature\" ORDER BY properties.name") {
                var results: [IceCreamLocation] = []
                let explain = try query.explain()
                print ("**EXPLAIN** \(explain)")
                for result in try query.execute() {
                    if let data = result.toJSON().data(using: .utf8){
                        let location = try JSONDecoder().decode(IceCreamLocation.self, from: data)
                        results.append(location)
                    }
                }
                self.iceCreamLocationList.send(results)
                self.iceCreamLocationList.send(completion: .finished)
            }
        } catch {
            print("**Error**: \(error)")
            self.iceCreamLocationList.send(completion: .failure(DbError.unknown))
        }
    }
}
