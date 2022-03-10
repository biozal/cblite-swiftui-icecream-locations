//
//  IceCreamListViewModel.swift
//  IceCreamLocator
//
//  Created by Aaron LaBeau on 3/8/22.
//

import Foundation
import Combine
import SwiftUI

extension IceCreamListView {
    @MainActor class IceCreamListViewModel : ObservableObject {
        
        var searchText = ""
        
        fileprivate var _repository: IceCreamLocationRepository
        
        @Published var unfilteredLocations = [IceCreamLocation]()
        @Published var selectedLocation: IceCreamLocation?
        
        private var subscriptions: Set<AnyCancellable> = []
        
        init() {
            _repository = IceCreamLocationRepository()
            _repository.iceCreamLocationList
                .sink(receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print (error)
                        break
                    }
                }, receiveValue: { [weak self] value in
                    self?.unfilteredLocations = value
                }).store(in: &subscriptions)
            
            //first example
            //_repository.getListByTypeCityOrderName()
            
            //second example
            //_repository.getListByStateGeorgia()
            
            //second example fixed
            _repository.getListByStateGeorgiaFixed()
        }
    }
}
