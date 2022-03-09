//
//  ContentView.swift
//  Shared
//
//  Created by Aaron LaBeau on 3/8/22.
//

import SwiftUI

struct IceCreamListView: View {
    @StateObject private var viewModel = IceCreamListViewModel()
    
    var body: some View {
        List(viewModel.unfilteredLocations) { location in
            Text(location.name)
                .padding()
            
        }
    }
}

struct IceCreamListView_Previews: PreviewProvider {
    static var previews: some View {
        IceCreamListView()
    }
}
