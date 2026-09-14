import XCTest
@testable import StickyStack

@MainActor
final class TodoListViewModelTests: XCTestCase {
    private let userId = UUID()

    func testLoad_createsWeekWhenMissingThenFetchesNotes() async {
        let weeksService = FakeWeeksService() // no weeks yet
        let notesService = FakeNotesService()
        let weekStart = DateUtils.currentWeekStart()
        notesService.notesToReturn = [
            Note(
                id: UUID(), userId: userId, weekId: UUID(), text: "Test note", status: .active,
                stackPosition: 0, createdAt: Date(), completedAt: nil, isHighlighted: false
            )
        ]
        let viewModel = TodoListViewModel(
            userId: userId, weeksService: weeksService, notesService: notesService
        )

        await viewModel.load()

        XCTAssertEqual(weeksService.ensureCurrentWeekCalls.count, 1)
        XCTAssertEqual(weeksService.ensureCurrentWeekCalls.first?.startDate, weekStart)
        XCTAssertNotNil(viewModel.week)
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testAddNote_appendsReturnedNote() async {
        let weeksService = FakeWeeksService()
        let week = Week(id: UUID(), userId: userId, startDate: DateUtils.currentWeekStart(), color: nil, createdAt: Date())
        weeksService.weeksToReturn = [week]
        let notesService = FakeNotesService()
        let viewModel = TodoListViewModel(userId: userId, weeksService: weeksService, notesService: notesService)
        await viewModel.load()

        await viewModel.addNote(text: "New task")

        XCTAssertEqual(notesService.addedNotes.count, 1)
        XCTAssertEqual(viewModel.notes.count, 1)
        XCTAssertEqual(viewModel.notes.first?.text, "New task")
    }

    func testMarkDone_removesNoteFromList() async {
        let weeksService = FakeWeeksService()
        let week = Week(id: UUID(), userId: userId, startDate: DateUtils.currentWeekStart(), color: nil, createdAt: Date())
        weeksService.weeksToReturn = [week]
        let note = Note(
            id: UUID(), userId: userId, weekId: week.id, text: "Finish this", status: .active,
            stackPosition: 0, createdAt: Date(), completedAt: nil, isHighlighted: false
        )
        let notesService = FakeNotesService()
        notesService.notesToReturn = [note]
        let viewModel = TodoListViewModel(userId: userId, weeksService: weeksService, notesService: notesService)
        await viewModel.load()

        await viewModel.markDone(note)

        XCTAssertEqual(notesService.doneNoteIds, [note.id])
        XCTAssertTrue(viewModel.notes.isEmpty)
    }

    func testToggleHighlight_flipsFlagAndPersists() async {
        let weeksService = FakeWeeksService()
        let week = Week(id: UUID(), userId: userId, startDate: DateUtils.currentWeekStart(), color: nil, createdAt: Date())
        weeksService.weeksToReturn = [week]
        let note = Note(
            id: UUID(), userId: userId, weekId: week.id, text: "Star me", status: .active,
            stackPosition: 0, createdAt: Date(), completedAt: nil, isHighlighted: false
        )
        let notesService = FakeNotesService()
        notesService.notesToReturn = [note]
        let viewModel = TodoListViewModel(userId: userId, weeksService: weeksService, notesService: notesService)
        await viewModel.load()

        await viewModel.toggleHighlight(note)

        XCTAssertEqual(notesService.highlightCalls.first?.isHighlighted, true)
        XCTAssertEqual(viewModel.notes.first?.isHighlighted, true)
    }
}
