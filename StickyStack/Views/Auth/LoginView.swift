import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    @State private var isSigningIn = false
    @State private var showSignup = false

    var body: some View {
        VStack(spacing: 16) {
            Text("STICKYSTACK")
                .font(.system(.largeTitle, design: .rounded, weight: .black))

            TextField("Email", text: $email)
                .textContentType(.emailAddress)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .textFieldStyle(NeoTextFieldStyle())

            SecureField("Password", text: $password)
                .textContentType(.password)
                .textFieldStyle(NeoTextFieldStyle())

            if let error = authViewModel.errorMessage {
                Text(error)
                    .foregroundStyle(Theme.Colors.error)
                    .font(.footnote)
            }

            Button {
                Task {
                    isSigningIn = true
                    await authViewModel.signIn(email: email, password: password)
                    isSigningIn = false
                }
            } label: {
                if isSigningIn {
                    ProgressView()
                } else {
                    Text("LOG IN")
                }
            }
            .buttonStyle(NeoButtonStyle(color: Theme.Colors.accent))
            .disabled(email.isEmpty || password.isEmpty || isSigningIn)

            Button("Need an account? Sign up") { showSignup = true }
                .font(.footnote)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.Colors.background)
        .sheet(isPresented: $showSignup) {
            SignupView().environmentObject(authViewModel)
        }
    }
}
