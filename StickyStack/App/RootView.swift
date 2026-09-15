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
                if let userId = authViewModel.currentUserId {
                    TodoListView(
                        viewModel: TodoListViewModel(
                            userId: userId,
                            weeksService: SupabaseWeeksService(client: SupabaseManager.shared),
                            notesService: SupabaseNotesService(client: SupabaseManager.shared)
                        )
                    )
                } else {
                    ProgressView()
                }
            }
        }
        .task { authViewModel.start() }
    }
}
