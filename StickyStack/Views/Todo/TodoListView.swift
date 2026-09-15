import SwiftUI

struct TodoListView: View {
    @StateObject private var viewModel: TodoListViewModel
    @State private var newNoteText = ""

    init(viewModel: @autoclosure @escaping () -> TodoListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel())
    }

    var body: some View {
        VStack(spacing: 16) {
            if let week = viewModel.week, week.color == nil {
                WeekColorPickerView { _, hex in
                    Task { await viewModel.setWeekColor(hex) }
                }
            }

            HStack {
                TextField("Add a task", text: $newNoteText)
                    .textFieldStyle(NeoTextFieldStyle())
                Button("Add") {
                    Task {
                        await viewModel.addNote(text: newNoteText)
                        newNoteText = ""
                    }
                }
                .buttonStyle(NeoButtonStyle(color: Theme.Colors.accent))
                .disabled(newNoteText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if let error = viewModel.errorMessage {
                Text(error).foregroundStyle(Theme.Colors.error).font(.footnote)
            }

            if viewModel.isLoading && viewModel.notes.isEmpty {
                ProgressView()
                Spacer()
            } else {
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(viewModel.notes) { note in
                            TodoRowView(
                                note: note,
                                onToggleDone: { Task { await viewModel.markDone(note) } },
                                onToggleHighlight: { Task { await viewModel.toggleHighlight(note) } }
                            )
                        }
                    }
                }
                .refreshable { await viewModel.load() }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Theme.Colors.background)
        .task { await viewModel.load() }
    }
}
