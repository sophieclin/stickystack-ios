import SwiftUI

enum Theme {
    enum Colors {
        static let background = Color(hex: "#FDF6EC")
        static let ink = Color.black
        static let accent = Color(hex: "#F6BD60")
        static let error = Color(hex: "#F25C54")

        /// Same palette as the web app's WEEK_COLORS (features/home/demoStack.ts),
        /// so a given week reads as the same color on both platforms.
        static let weekPalette: [Color] = [
            Color(hex: "#6699CC"),
            Color(hex: "#84A98C"),
            Color(hex: "#F6BD60"),
            Color(hex: "#F2A6C9"),
            Color(hex: "#F4A259"),
            Color(hex: "#F25C54"),
        ]
    }

    static let borderWidth: CGFloat = 3
    static let cornerRadius: CGFloat = 4
    static let shadowOffset = CGSize(width: 4, height: 4)
}

extension Color {
    init(hex: String) {
        let sanitized = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        var value: UInt64 = 0
        Scanner(string: sanitized).scanHexInt64(&value)
        let r = Double((value >> 16) & 0xFF) / 255
        let g = Double((value >> 8) & 0xFF) / 255
        let b = Double(value & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
}
