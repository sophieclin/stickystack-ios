import Foundation

@MainActor
final class TodoListViewModel: ObservableObject {
    @Published private(set) var week: Week?
    @Published private(set) var notes: [Note] = []
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?

    private let userId: UUID
    private let weeksService: WeeksServicing
    private let notesService: NotesServicing

    init(userId: UUID, weeksService: WeeksServicing, notesService: NotesServicing) {
        self.userId = userId
        self.weeksService = weeksService
        self.notesService = notesService
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }
        do {
            let weekStart = DateUtils.currentWeekStart()
            var weeks = try await weeksService.fetchWeeks(userId: userId)
            var currentWeek = weeks.first { $0.startDate == weekStart }
            if currentWeek == nil {
                try await weeksService.ensureCurrentWeek(userId: userId, startDate: weekStart)
                weeks = try await weeksService.fetchWeeks(userId: userId)
                currentWeek = weeks.first { $0.startDate == weekStart }
            }
            week = currentWeek
            if let currentWeek {
                notes = try await notesService.fetchActiveNotes(weekIds: [currentWeek.id])
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func addNote(text: String) async {
        guard let week, !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        do {
            let note = try await notesService.addNote(userId: userId, weekId: week.id, text: text)
            notes.append(note)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func markDone(_ note: Note) async {
        do {
            try await notesService.setDone(noteId: note.id)
            notes.removeAll { $0.id == note.id }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func toggleHighlight(_ note: Note) async {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        let newValue = !notes[index].isHighlighted
        do {
            try await notesService.setHighlighted(noteId: note.id, isHighlighted: newValue)
            notes[index].isHighlighted = newValue
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func setWeekColor(_ color: String) async {
        guard let week else { return }
        do {
            try await weeksService.setColor(weekId: week.id, color: color)
            self.week?.color = color
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
