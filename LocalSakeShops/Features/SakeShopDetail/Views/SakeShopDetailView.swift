import SwiftUI

/// The detail screen for a single sake shop.
///
/// Displays the shop photo (with placeholder), name, star rating, description,
/// a tappable address button, and a website button. Controls are hidden when the
/// corresponding URL is absent, satisfying FR-009 and FR-010.
struct SakeShopDetailView: View {

    /// The ViewModel providing shop data and URL-opening actions.
    @State var viewModel: SakeShopDetailViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: DSSpacing.md) {

                // MARK: Shop photo
                AsyncImage(url: viewModel.shop.pictureURL) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure, .empty:
                        Image(systemName: DSIcon.shopPlaceholder)
                            .font(.system(size: DSSpacing.iconLarge))
                            .foregroundStyle(DSColor.subdued)
                            .frame(maxWidth: .infinity)
                    @unknown default:
                        Color.clear
                    }
                }
                .frame(maxWidth: .infinity)
                .frame(height: 200)
                .clipped()
                .background(DSColor.surface)

                VStack(alignment: .leading, spacing: DSSpacing.sm) {
                    // MARK: Address (tappable when mapsURL exists)
                    if viewModel.canOpenMaps {
                        MapCardView(address: viewModel.shop.address, action: viewModel.openMaps)
                    }
                    
                    // MARK: Name
                    Text(viewModel.shop.name)
                        .dsTextStyle(DSTypography.headlineMedium)
                        .padding(.horizontal, DSSpacing.margin)

                    // MARK: Star rating
                    StarRatingView(rating: viewModel.shop.rating)
                        .padding(.horizontal, DSSpacing.margin)

                    // MARK: Description
                    Text(viewModel.shop.description)
                        .dsTextStyle(DSTypography.bodyMedium)
                        .padding(.horizontal, DSSpacing.margin)
                }
                .padding(.bottom, DSSpacing.lg)
            }
        }
        .navigationTitle(viewModel.shop.name)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) {
            // MARK: Website button (hidden when websiteURL is nil)
            if viewModel.canOpenWebsite {
                DSPrimaryButton(label: "Visit Website") {
                    viewModel.openWebsite()
                }
                .padding(.horizontal, DSSpacing.margin)
                .padding(.top, DSSpacing.xs)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SakeShopDetailView(viewModel: SakeShopDetailViewModel(shop: SakeShop(
            id: UUID(),
            name: "Endo Brewery",
            description: "Historic brewery known for its Keiryu brand sake.",
            pictureURL: URL(string: "https://www.keiryu.jp/img_201904/head_parts/shop_img.png"),
            rating: 4.5,
            address: "〒382-0086 長野県須坂市大字須坂 29",
            mapsURL: URL(string: "https://maps.app.goo.gl/f288RPXsgHRch3297"),
            websiteURL: URL(string: "https://www.keiryu.jp/")
        )))
    }
}
