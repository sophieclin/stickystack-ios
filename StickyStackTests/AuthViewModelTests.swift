import XCTest
@testable import StickyStack

@MainActor
final class AuthViewModelTests: XCTestCase {
    private struct SampleError: Error {}

    func testStart_resolvesSignedOutWhenNoSession() async {
        let fake = FakeAuthService()
        fake.currentSession = nil
        let viewModel = AuthViewModel(authService: fake)

        viewModel.start()
        // Let the Task inside start() run its first iteration.
        await Task.yield()

        XCTAssertEqual(viewModel.state, .signedOut)
    }

    func testSignUp_delegatesToService() async {
        let fake = FakeAuthService()
        let viewModel = AuthViewModel(authService: fake)

        await viewModel.signUp(email: "a@example.com", password: "hunter2", username: "sophie")

        XCTAssertEqual(fake.signUpCalls.count, 1)
        XCTAssertEqual(fake.signUpCalls.first?.email, "a@example.com")
        XCTAssertEqual(fake.signUpCalls.first?.username, "sophie")
        XCTAssertNil(viewModel.errorMessage)
    }

    func testSignIn_setsErrorMessageOnFailure() async {
        let fake = FakeAuthService()
        fake.errorToThrow = SampleError()
        let viewModel = AuthViewModel(authService: fake)

        await viewModel.signIn(email: "a@example.com", password: "wrong")

        XCTAssertNotNil(viewModel.errorMessage)
    }
}
