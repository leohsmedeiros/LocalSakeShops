import SwiftUI

/// A single row in the sake shop list.
///
/// Displays the shop name, address, and a star rating side by side.
/// Minimum row height is 72pt to provide a comfortable tap target.
struct SakeShopRowView: View {

    /// The sake shop to display.
    let shop: SakeShop

    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: shop.pictureURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure, .empty:
                    Image(systemName: "wineglass")
                        .font(.title2)
                        .foregroundStyle(.secondary)
                @unknown default:
                    Color.clear
                }
            }
            .frame(width: 80, height: 80)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .background(Color(.systemGray5), in: RoundedRectangle(cornerRadius: 10))

            VStack(alignment: .leading, spacing: 4) {
                Text(shop.name)
                    .font(.headline)
                    .lineLimit(1)
                Text(shop.address)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                StarRatingView(rating: shop.rating)
            }

            Spacer(minLength: 0)
        }
        .padding()
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    List {
        SakeShopRowView(shop: SakeShop(
            id: UUID(),
            name: "Endo Brewery",
            description: "Historic brewery.",
            pictureURL: nil,
            rating: 4.5,
            address: "〒382-0086 長野県須坂市大字須坂 29",
            mapsURL: URL(string: "https://maps.app.goo.gl/f288RPXsgHRch3297"),
            websiteURL: URL(string: "https://www.keiryu.jp/")
        ))
        SakeShopRowView(shop: SakeShop(
            id: UUID(),
            name: "Midori Nagano",
            description: "Shopping center.",
            pictureURL: nil,
            rating: 4.0,
            address: "〒380-0824 長野県長野市南長野南石堂町 1421",
            mapsURL: nil,
            websiteURL: nil
        ))
    }
}
