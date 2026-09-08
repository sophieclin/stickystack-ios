import Foundation

enum NoteStatus: String, Codable, Equatable {
    case active
    case done
}

struct Note: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let weekId: UUID
    var text: String
    var status: NoteStatus
    let stackPosition: Int
    let createdAt: Date
    var completedAt: Date?
    var isHighlighted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case weekId = "week_id"
        case text
        case status
        case stackPosition = "stack_position"
        case createdAt = "created_at"
        case completedAt = "completed_at"
        case isHighlighted = "is_highlighted"
    }
}
