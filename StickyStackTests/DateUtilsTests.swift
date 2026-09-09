import XCTest
@testable import StickyStack

final class DateUtilsTests: XCTestCase {
    private var utcCalendar: Calendar {
        var cal = Calendar(identifier: .gregorian)
        cal.timeZone = TimeZone(identifier: "UTC")!
        return cal
    }

    func testCurrentWeekStart_returnsPrecedingMondayForMidWeekDate() {
        // Wednesday, January 7, 2026
        let wednesday = utcCalendar.date(from: DateComponents(year: 2026, month: 1, day: 7))!

        let result = DateUtils.currentWeekStart(now: wednesday, calendar: utcCalendar)

        XCTAssertEqual(result, "2026-01-05")
    }

    func testCurrentWeekStart_returnsSameDayWhenAlreadyMonday() {
        let monday = utcCalendar.date(from: DateComponents(year: 2026, month: 1, day: 5))!

        let result = DateUtils.currentWeekStart(now: monday, calendar: utcCalendar)

        XCTAssertEqual(result, "2026-01-05")
    }

    func testIsWeekArchived_falseWithinWindow() {
        let now = utcCalendar.date(from: DateComponents(year: 2026, month: 3, day: 1))!

        XCTAssertFalse(
            DateUtils.isWeekArchived(
                weekStartDate: "2026-01-05", archiveMonths: 2, now: now, calendar: utcCalendar
            )
        )
    }

    func testIsWeekArchived_trueOutsideWindow() {
        let now = utcCalendar.date(from: DateComponents(year: 2026, month: 3, day: 1))!

        XCTAssertTrue(
            DateUtils.isWeekArchived(
                weekStartDate: "2025-11-01", archiveMonths: 2, now: now, calendar: utcCalendar
            )
        )
    }
}
