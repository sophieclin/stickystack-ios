import Foundation
import Supabase

// `: Sendable` required for the same reason as AuthServicing (Task 6): TodoListViewModel
// is @MainActor and calls this protocol's methods from inside `async` functions whose
// existential parameter (`any WeeksServicing`) must be Sendable to cross that isolation
// boundary under Swift 6 strict concurrency.
protocol WeeksServicing: Sendable {
    func fetchWeeks(userId: UUID) async throws -> [Week]
    func ensureCurrentWeek(userId: UUID, startDate: String) async throws
    func setColor(weekId: UUID, color: String) async throws
}

struct SupabaseWeeksService: WeeksServicing {
    let client: SupabaseClient

    func fetchWeeks(userId: UUID) async throws -> [Week] {
        try await client
            .from("weeks")
            .select()
            .eq("user_id", value: userId)
            .order("start_date", ascending: false)
            .execute()
            .value
    }

    /// Idempotent: relies on the (user_id, start_date) unique constraint plus
    /// ignoreDuplicates, same as the web app's useCurrentWeek.
    func ensureCurrentWeek(userId: UUID, startDate: String) async throws {
        struct NewWeek: Encodable {
            let userId: UUID
            let startDate: String
            enum CodingKeys: String, CodingKey {
                case userId = "user_id"
                case startDate = "start_date"
            }
        }
        try await client
            .from("weeks")
            .upsert(
                NewWeek(userId: userId, startDate: startDate),
                onConflict: "user_id,start_date",
                ignoreDuplicates: true
            )
            .execute()
    }

    func setColor(weekId: UUID, color: String) async throws {
        try await client
            .from("weeks")
            .update(["color": color])
            .eq("id", value: weekId)
            .execute()
    }
}
