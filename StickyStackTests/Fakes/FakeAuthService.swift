import Foundation
import Supabase
@testable import StickyStack

// `@unchecked Sendable`: this fake carries mutable `var` state (`currentSession`,
// `continuation`, the call-recording arrays), but it's only ever driven single-threaded
// within one async test method — never accessed concurrently — so the compiler's
// inferred non-Sendability is a false positive here, not a real data race.
final class FakeAuthService: AuthServicing, @unchecked Sendable {
    var currentSession: Session?
    private var continuation: AsyncStream<(AuthChangeEvent, Session?)>.Continuation?
    private(set) var signUpCalls: [(email: String, password: String, username: String)] = []
    private(set) var signInCalls: [(email: String, password: String)] = []
    var errorToThrow: Error?

    func authStateChanges() -> AsyncStream<(AuthChangeEvent, Session?)> {
        AsyncStream { continuation in
            self.continuation = continuation
        }
    }

    func signUp(email: String, password: String, username: String) async throws {
        signUpCalls.append((email, password, username))
        if let errorToThrow { throw errorToThrow }
    }

    func signIn(email: String, password: String) async throws {
        signInCalls.append((email, password))
        if let errorToThrow { throw errorToThrow }
    }

    func signOut() async throws {
        if let errorToThrow { throw errorToThrow }
    }
}
