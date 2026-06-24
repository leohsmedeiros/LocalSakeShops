import SwiftUI

/// The root list screen showing all local sake shops.
///
/// Handles all `ViewState` cases: loading spinner, shop list, empty state, and error
/// message. Navigation to the detail screen is driven by `NavigationStack` typed
/// destinations — the destination is wired in T029 once `SakeShopDetailView` exists.
struct SakeShopListView: View {

    /// The ViewModel providing shop data and state transitions.
    @State var viewModel: SakeShopListViewModel

    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .idle:
                    Color.clear

                case .loading:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)

                case .success(let shops):
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(shops) { shop in
                                NavigationLink(value: shop) {
                                    SakeShopRowView(shop: shop)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, DSSpacing.margin)
                    }
                case .empty:
                    ContentUnavailableView(
                        "No Sake Shops Found",
                        systemImage: DSIcon.map,
                        description: Text("There are no sake shops available right now.")
                    )

                case .error(let message):
                    VStack(spacing: DSSpacing.md) {
                        Image(systemName: DSIcon.info)
                            .font(.system(size: DSSpacing.iconLarge))
                            .foregroundStyle(DSColor.error)
                        Text(message)
                            .dsTextStyle(DSTypography.bodyMedium, color: DSColor.error)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, DSSpacing.margin)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .navigationTitle("Local Sake Shops")
            .navigationDestination(for: SakeShop.self) { shop in
                SakeShopDetailView(
                    viewModel: SakeShopDetailViewModel(shop: shop)
                )
            }
            .task {
                await viewModel.loadShops()
            }
        }
    }
}

#Preview {
    SakeShopListView(viewModel: SakeShopListViewModel(
        fetchShops: FetchSakeShopsUseCase(
            repository: SakeShopRepository(
                dataSource: BundledJSONDataSource()
            )
        )
    ))
}
