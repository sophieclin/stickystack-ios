import Foundation
import Supabase

@MainActor
final class AuthViewModel: ObservableObject {
    enum AuthState: Equatable {
        case loading
        case signedOut
        case signedIn
    }

    @Published private(set) var state: AuthState = .loading
    @Published private(set) var currentUserId: UUID?
    @Published var errorMessage: String?

    private let authService: AuthServicing
    private var listenTask: Task<Void, Never>?

    init(authService: AuthServicing) {
        self.authService = authService
    }

    func start() {
        listenTask?.cancel()
        listenTask = Task {
            await resolve(session: await authService.currentSession)
            for await (_, session) in authService.authStateChanges() {
                await resolve(session: session)
            }
        }
    }

    private func resolve(session: Session?) async {
        currentUserId = session?.user.id
        state = session == nil ? .signedOut : .signedIn
    }

    func signUp(email: String, password: String, username: String) async {
        errorMessage = nil
        do {
            try await authService.signUp(email: email, password: password, username: username)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signIn(email: String, password: String) async {
        errorMessage = nil
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func signOut() async {
        do {
            try await authService.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
