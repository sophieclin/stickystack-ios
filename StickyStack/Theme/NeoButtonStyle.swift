import SwiftUI

struct NeoButtonStyle: ButtonStyle {
    var color: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(.body, design: .rounded, weight: .heavy))
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(color)
            .foregroundStyle(Theme.Colors.ink)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(Theme.Colors.ink, lineWidth: Theme.borderWidth)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .offset(
                x: configuration.isPressed ? 0 : -Theme.shadowOffset.width / 2,
                y: configuration.isPressed ? 0 : -Theme.shadowOffset.height / 2
            )
            .background(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .fill(Theme.Colors.ink)
                    .offset(x: Theme.shadowOffset.width / 2, y: Theme.shadowOffset.height / 2)
                    .opacity(configuration.isPressed ? 0 : 1)
            )
            .animation(.easeOut(duration: 0.08), value: configuration.isPressed)
    }
}
