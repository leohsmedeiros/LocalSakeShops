import SwiftUI

/// A read-only star rating display component.
///
/// Renders a row of star icons (filled, half-filled, or empty) representing a
/// decimal rating value. Stars are display-only — not interactive.
///
/// ```swift
/// StarRatingView(rating: 4.5)
/// StarRatingView(rating: 3.0, maxStars: 5)
/// ```
struct StarRatingView: View {

    /// The decimal rating to visualise, typically in the range 0–5.
    let rating: Double

    /// Total number of star slots to render.
    var maxStars: Int = 5

    var body: some View {
        HStack(spacing: DSSpacing.xs) {
            ForEach(0..<maxStars, id: \.self) { index in
                Image(systemName: iconName(for: index))
                    .foregroundStyle(DSColor.secondary)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("\(formattedRating) out of \(maxStars) stars")
    }

    // MARK: - Private

    private var formattedRating: String {
        let formatted = String(format: "%.1f", rating)
        return formatted
    }

    private func iconName(for index: Int) -> String {
        let threshold = Double(index) + 0.5
        if rating >= Double(index + 1) {
            return DSIcon.starFill
        } else if rating >= threshold {
            return DSIcon.starHalfFill
        } else {
            return DSIcon.star
        }
    }
}

#Preview {
    VStack(spacing: DSSpacing.md) {
        StarRatingView(rating: 5.0)
        StarRatingView(rating: 4.6)
        StarRatingView(rating: 4.5)
        StarRatingView(rating: 3.2)
        StarRatingView(rating: 0.0)
    }
    .padding(DSSpacing.md)
}
