import Foundation

struct Week: Codable, Identifiable, Equatable {
    let id: UUID
    let userId: UUID
    let startDate: String // yyyy-MM-dd, Monday of the week
    var color: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case startDate = "start_date"
        case color
        case createdAt = "created_at"
    }
}
