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
            VStack(alignment: .leading) {
                nameView(location: location)
                streetView(location: location)
                addressView(location: location)
            }.padding(.bottom, 10)
        }
    }

    func nameView(location: IceCreamLocation) -> some View {
        return AnyView(Text(location.name))
    }
    
    func streetView(location: IceCreamLocation) -> some View {
        if let addrHousenumber = location.addrHousenumber, let addrStreet = location.addrStreet {
            return AnyView(
                Text(addrHousenumber.trimmingCharacters(in: .whitespacesAndNewlines))
                + Text(" ")
                + Text(addrStreet)
            )
        }
        return AnyView(EmptyView())
    }
    
    func addressView(location: IceCreamLocation) -> some View {
        if let addrCity = location.addrCity,
           let addrState = location.addrState,
           let addrPostalCode = location.addrPostcode {
            return AnyView (
                    Text(addrCity.trimmingCharacters(in: .whitespacesAndNewlines))
                    + Text(", ")
                    + Text(addrState)
                    + Text("  ")
                    + Text(addrPostalCode)
            )
        }
        return AnyView(EmptyView())
    }
}


struct IceCreamListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            IceCreamListView()
            IceCreamListView()
        }
    }
}
