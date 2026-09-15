import SwiftUI

struct SignupView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningUp = false

    var body: some View {
        VStack(spacing: 16) {
            Text("CREATE ACCOUNT")
                .font(.system(.title, weight: .black))

            TextField("Username", text: $username)
                .textInputAutocapitalization(.never)
                .textFieldStyle(NeoTextFieldStyle())

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(NeoTextFieldStyle())

            SecureField("Password", text: $password)
                .textContentType(.newPassword)
                .textFieldStyle(NeoTextFieldStyle())

            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundStyle(Theme.Colors.error)
                    .font(.footnote)
            }

            Button {
                Task {
                    isSigningUp = true
                    await authViewModel.signUp(email: email, password: password, username: username)
                    isSigningUp = false
                    if authViewModel.errorMessage == nil { dismiss() }
                }
            } label: {
                if isSigningUp {
                    ProgressView()
                } else {
                    Text("SIGN UP")
                }
            }
            .buttonStyle(NeoButtonStyle(color: Theme.Colors.accent))
            .disabled(username.count < 2 || email.isEmpty || password.count < 6 || isSigningUp)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.Colors.background)
    }
}
