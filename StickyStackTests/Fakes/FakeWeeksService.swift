import Foundation
@testable import StickyStack

// @unchecked Sendable: single-threaded test-double usage only, same justification as
// FakeAuthService in Task 6.
final class FakeWeeksService: WeeksServicing, @unchecked Sendable {
    var weeksToReturn: [Week] = []
    private(set) var ensureCurrentWeekCalls: [(userId: UUID, startDate: String)] = []
    private(set) var setColorCalls: [(weekId: UUID, color: String)] = []
    var errorToThrow: Error?

    func fetchWeeks(userId: UUID) async throws -> [Week] {
        if let errorToThrow { throw errorToThrow }
        return weeksToReturn
    }

    func ensureCurrentWeek(userId: UUID, startDate: String) async throws {
        ensureCurrentWeekCalls.append((userId, startDate))
        if let errorToThrow { throw errorToThrow }
        weeksToReturn.append(
            Week(id: UUID(), userId: userId, startDate: startDate, color: nil, createdAt: Date())
        )
    }

    func setColor(weekId: UUID, color: String) async throws {
        setColorCalls.append((weekId, color))
        if let errorToThrow { throw errorToThrow }
    }
}
