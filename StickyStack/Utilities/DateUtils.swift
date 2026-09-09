import Foundation

enum DateUtils {
    /// Monday of the week containing `now`, as a yyyy-MM-dd string.
    static func currentWeekStart(now: Date = Date(), calendar: Calendar = .current) -> String {
        var cal = calendar
        cal.firstWeekday = 2 // Monday
        let monday = cal.dateInterval(of: .weekOfYear, for: now)?.start ?? now
        return dateString(from: monday, calendar: cal)
    }

    /// True if a week whose Monday is `weekStartDate` (yyyy-MM-dd) is older than
    /// `archiveMonths`.
    static func isWeekArchived(
        weekStartDate: String, archiveMonths: Int, now: Date = Date(), calendar: Calendar = .current
    ) -> Bool {
        guard let weekStart = date(fromDateString: weekStartDate, calendar: calendar) else {
            return false
        }
        guard let cutoff = calendar.date(byAdding: .month, value: -archiveMonths, to: now) else {
            return false
        }
        return weekStart < cutoff
    }

    private static func dateString(from date: Date, calendar: Calendar) -> String {
        let c = calendar.dateComponents([.year, .month, .day], from: date)
        return String(format: "%04d-%02d-%02d", c.year!, c.month!, c.day!)
    }

    private static func date(fromDateString string: String, calendar: Calendar) -> Date? {
        let parts = string.split(separator: "-").compactMap { Int($0) }
        guard parts.count == 3 else { return nil }
        return calendar.date(from: DateComponents(year: parts[0], month: parts[1], day: parts[2]))
    }
}
