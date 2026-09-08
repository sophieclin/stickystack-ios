import XCTest
import Supabase
@testable import StickyStack

final class ModelDecodingTests: XCTestCase {
    // The same decoder PostgrestClient uses internally for `.execute().value`,
    // so these tests prove real Postgrest responses decode correctly.
    private let decoder = PostgrestClient.Configuration.jsonDecoder

    func testDecodesNoteFromPostgrestJSON() throws {
        let json = """
        {
          "id": "8f14e45f-ceea-467e-95a5-1a3ac0dc8b3e",
          "user_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "week_id": "3fa85f64-5717-4562-b3fc-2c963f66afa7",
          "text": "Ship the report",
          "status": "active",
          "stack_position": 42,
          "created_at": "2026-01-05T09:30:00.000000+00:00",
          "completed_at": null,
          "is_highlighted": true
        }
        """.data(using: .utf8)!

        let note = try decoder.decode(Note.self, from: json)

        XCTAssertEqual(note.text, "Ship the report")
        XCTAssertEqual(note.status, .active)
        XCTAssertEqual(note.stackPosition, 42)
        XCTAssertNil(note.completedAt)
        XCTAssertTrue(note.isHighlighted)
    }

    func testDecodesWeekFromPostgrestJSON() throws {
        let json = """
        {
          "id": "3fa85f64-5717-4562-b3fc-2c963f66afa7",
          "user_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "start_date": "2026-01-05",
          "color": "#F6BD60",
          "created_at": "2026-01-05T09:00:00.000000+00:00"
        }
        """.data(using: .utf8)!

        let week = try decoder.decode(Week.self, from: json)

        XCTAssertEqual(week.startDate, "2026-01-05")
        XCTAssertEqual(week.color, "#F6BD60")
    }

    func testDecodesUserSettingsFromPostgrestJSON() throws {
        let json = """
        {
          "user_id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
          "archive_months": 2,
          "handwriting_font": "patrick-hand",
          "username": "sophie",
          "visual_mode": "stars"
        }
        """.data(using: .utf8)!

        let settings = try decoder.decode(UserSettings.self, from: json)

        XCTAssertEqual(settings.handwritingFont, .patrickHand)
        XCTAssertEqual(settings.visualMode, .stars)
        XCTAssertEqual(settings.username, "sophie")
    }
}
