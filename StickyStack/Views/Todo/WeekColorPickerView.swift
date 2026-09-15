import SwiftUI

struct WeekColorPickerView: View {
    let onPick: (Color, String) -> Void

    private let palette: [(Color, String)] = [
        (Color(hex: "#6699CC"), "#6699CC"),
        (Color(hex: "#84A98C"), "#84A98C"),
        (Color(hex: "#F6BD60"), "#F6BD60"),
        (Color(hex: "#F2A6C9"), "#F2A6C9"),
        (Color(hex: "#F4A259"), "#F4A259"),
        (Color(hex: "#F25C54"), "#F25C54"),
    ]

    var body: some View {
        VStack(spacing: 8) {
            Text("Pick this week's color")
                .font(.system(.footnote, design: .rounded, weight: .heavy))
            HStack(spacing: 8) {
                ForEach(palette, id: \.1) { color, hex in
                    Button {
                        onPick(color, hex)
                    } label: {
                        Circle()
                            .fill(color)
                            .frame(width: 32, height: 32)
                            .overlay(Circle().stroke(Theme.Colors.ink, lineWidth: Theme.borderWidth))
                    }
                }
            }
        }
    }
}
