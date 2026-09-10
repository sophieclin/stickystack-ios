import Foundation
import Supabase

protocol AuthServicing: Sendable {
    var currentSession: Session? { get async }
    func authStateChanges() -> AsyncStream<(AuthChangeEvent, Session?)>
    func signUp(email: String, password: String, username: String) async throws
    func signIn(email: String, password: String) async throws
    func signOut() async throws
}

struct SupabaseAuthService: AuthServicing {
    let client: SupabaseClient

    var currentSession: Session? {
        get async { try? await client.auth.session }
    }

    func authStateChanges() -> AsyncStream<(AuthChangeEvent, Session?)> {
        AsyncStream { continuation in
            let task = Task {
                for await change in await client.auth.authStateChanges {
                    continuation.yield(change)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    func signUp(email: String, password: String, username: String) async throws {
        try await client.auth.signUp(
            email: email,
            password: password,
            data: ["username": .string(username)]
        )
    }

    func signIn(email: String, password: String) async throws {
        try await client.auth.signIn(email: email, password: password)
    }

    func signOut() async throws {
        try await client.auth.signOut()
    }
}
