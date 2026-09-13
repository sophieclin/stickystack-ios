import Foundation
import Supabase

// `: Sendable` required for the same reason as AuthServicing (Task 6) / WeeksServicing (Task 9).
protocol NotesServicing: Sendable {
    func fetchActiveNotes(weekIds: [UUID]) async throws -> [Note]
    func addNote(userId: UUID, weekId: UUID, text: String) async throws -> Note
    func setDone(noteId: UUID) async throws
    func setHighlighted(noteId: UUID, isHighlighted: Bool) async throws
}

struct SupabaseNotesService: NotesServicing {
    let client: SupabaseClient

    func fetchActiveNotes(weekIds: [UUID]) async throws -> [Note] {
        try await client
            .from("notes")
            .select()
            .in("week_id", values: weekIds)
            .eq("status", value: "active")
            .order("stack_position", ascending: true)
            .execute()
            .value
    }

    func addNote(userId: UUID, weekId: UUID, text: String) async throws -> Note {
        struct NewNote: Encodable {
            let userId: UUID
            let weekId: UUID
            let text: String
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case weekId = "week_id"
                case text
            }
        }
        return try await client
            .from("notes")
            .insert(NewNote(userId: userId, weekId: weekId, text: text))
            .select()
            .single()
            .execute()
            .value
    }

    func setDone(noteId: UUID) async throws {
        struct DoneUpdate: Encodable {
            let status = "done"
            let completedAt: String
            enum CodingKeys: String, CodingKey {
                case status
                case completedAt = "completed_at"
            }
        }
        let update = DoneUpdate(completedAt: ISO8601DateFormatter().string(from: Date()))
        try await client
            .from("notes")
            .update(update)
            .eq("id", value: noteId)
            .execute()
    }

    func setHighlighted(noteId: UUID, isHighlighted: Bool) async throws {
        try await client
            .from("notes")
            .update(["is_highlighted": isHighlighted])
            .eq("id", value: noteId)
            .execute()
    }
}
