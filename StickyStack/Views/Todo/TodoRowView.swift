import SwiftUI

struct TodoRowView: View {
    let note: Note
    let onToggleDone: () -> Void
    let onToggleHighlight: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggleDone) {
                Image(systemName: "square")
                    .font(.title3)
            }
            .buttonStyle(.plain)

            Text(note.text)
                .frame(maxWidth: .infinity, alignment: .leading)

            Button(action: onToggleHighlight) {
                Image(systemName: note.isHighlighted ? "star.fill" : "star")
                    .foregroundStyle(note.isHighlighted ? Theme.Colors.accent : Theme.Colors.ink)
            }
            .buttonStyle(.plain)
        }
        .padding(12)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: Theme.cornerRadius)
                .stroke(Theme.Colors.ink, lineWidth: Theme.borderWidth)
        )
    }
}
