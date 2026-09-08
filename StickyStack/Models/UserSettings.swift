import Foundation

enum HandwritingFont: String, Codable, CaseIterable, Equatable {
    case caveat
    case kalam
    case patrickHand = "patrick-hand"
    case shadowsIntoLight = "shadows-into-light"
}

enum VisualMode: String, Codable, Equatable {
    case notes
    case stars
}

struct UserSettings: Codable, Equatable {
    let userId: UUID
    var archiveMonths: Int
    var handwritingFont: HandwritingFont
    var username: String?
    var visualMode: VisualMode

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case archiveMonths = "archive_months"
        case handwritingFont = "handwriting_font"
        case username
        case visualMode = "visual_mode"
    }
}
