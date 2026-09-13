import SwiftUI

@main
struct StickyStackApp: App {
    @StateObject private var authViewModel = AuthViewModel(
        authService: SupabaseAuthService(client: SupabaseManager.shared)
    )

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authViewModel)
        }
    }
}
