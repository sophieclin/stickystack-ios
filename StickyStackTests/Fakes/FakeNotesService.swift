import Foundation
@testable import StickyStack

// @unchecked Sendable: single-threaded test-double usage only, same justification as
// FakeAuthService in Task 6.
final class FakeNotesService: NotesServicing, @unchecked Sendable {
    var notesToReturn: [Note] = []
    private(set) var addedNotes: [(userId: UUID, weekId: UUID, text: String)] = []
    private(set) var doneNoteIds: [UUID] = []
    private(set) var highlightCalls: [(noteId: UUID, isHighlighted: Bool)] = []
    var errorToThrow: Error?

    func fetchActiveNotes(weekIds: [UUID]) async throws -> [Note] {
        if let errorToThrow { throw errorToThrow }
        return notesToReturn
    }

    func addNote(userId: UUID, weekId: UUID, text: String) async throws -> Note {
        addedNotes.append((userId, weekId, text))
        if let errorToThrow { throw errorToThrow }
        return Note(
            id: UUID(), userId: userId, weekId: weekId, text: text, status: .active,
            stackPosition: notesToReturn.count, createdAt: Date(), completedAt: nil,
            isHighlighted: false
        )
    }

    func setDone(noteId: UUID) async throws {
        doneNoteIds.append(noteId)
        if let errorToThrow { throw errorToThrow }
    }

    func setHighlighted(noteId: UUID, isHighlighted: Bool) async throws {
        highlightCalls.append((noteId, isHighlighted))
        if let errorToThrow { throw errorToThrow }
    }
}
