//
//  ContentView.swift
//  LocalSakeShops
//
//  Created by Leonardo Medeiros on 23/06/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        SakeShopListView(
            viewModel: SakeShopListViewModel(
                fetchShops: FetchSakeShopsUseCase(
                    repository: SakeShopRepository(
                        dataSource: BundledJSONDataSource()
                    )
                )
            )
        )
    }
}

#Preview {
    ContentView()
}

