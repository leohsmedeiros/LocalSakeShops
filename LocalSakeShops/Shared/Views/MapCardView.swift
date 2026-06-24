//
//  MapCardView.swift
//  LocalSakeShops
//
//  Created by Leonardo Medeiros on 24/06/26.
//

import SwiftUI

struct MapCardView: View {
    let address: String
    let action: () -> Void

    var body: some View {
        DSCard(content:  {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .center) {
                    Image(systemName: DSIcon.map)
                    Text("Location")
                        .font(.headline)
                        .lineLimit(1)
                }
                .frame(maxWidth: .infinity)
                
                Text(address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                
                DSSecondaryButton(label: "Get Directions", action: self.action)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }, backgroundColor: DSColor.background)
        .padding(DSSpacing.md)
    }
}

#Preview {
    MapCardView(address: "Any address", action: {})
}
