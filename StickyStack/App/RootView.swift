import SwiftUI

struct RootView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel

    var body: some View {
        Group {
            switch authViewModel.state {
            case .loading:
                ProgressView()
            case .signedOut:
                LoginView()
            case .signedIn:
                // Replaced with TodoListView in Task 12.
                Text("Signed in")
            }
        }
        .task { authViewModel.start() }
    }
}
