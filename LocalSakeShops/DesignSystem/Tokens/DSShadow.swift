import SwiftUI

/// A single shadow definition expressing one elevation level.
struct DSShadow {
    /// The shadow tint color (typically a semi-transparent dark).
    let color: Color
    /// The blur radius in points.
    let radius: CGFloat
    /// Horizontal offset in points.
    let x: CGFloat
    /// Vertical offset in points.
    let y: CGFloat

    /// No shadow — flat, zero-elevation surfaces.
    static let none = DSShadow(color: .clear, radius: 0, x: 0, y: 0)

    /// Low elevation — cards and interactive list items.
    static let low = DSShadow(
        color: Color.black.opacity(0.08),
        radius: 4,
        x: 0,
        y: 2
    )

    /// Medium elevation — sheets, drawers, and dropdowns.
    static let medium = DSShadow(
        color: Color.black.opacity(0.12),
        radius: 12,
        x: 0,
        y: 4
    )

    /// High elevation — modals and floating action elements.
    static let high = DSShadow(
        color: Color.black.opacity(0.18),
        radius: 24,
        x: 0,
        y: 8
    )
}

extension View {
    /// Applies a design-system shadow token to the view.
    func dsShadow(_ shadow: DSShadow) -> some View {
        self.shadow(
            color: shadow.color,
            radius: shadow.radius,
            x: shadow.x,
            y: shadow.y
        )
    }
}
