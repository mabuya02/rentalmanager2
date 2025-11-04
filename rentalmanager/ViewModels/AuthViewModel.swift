//
//  AuthViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI
import Combine
import FirebaseAuth

// MARK: - Struct for alert messages
struct AlertMessage: Identifiable {
    let id = UUID()
    let message: String
}

// MARK: - ViewModel for Authentication
@MainActor
class AuthViewModel: ObservableObject {

    // MARK: - Published properties
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isAuthenticated: Bool = false
    @Published var isLoading: Bool = false
    @Published var alertMessage: AlertMessage?
    @Published var userEmail: String = ""
    @Published var userId: String = ""   

    // MARK: - Firebase state listener
    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    // MARK: - Initialization
    init() {
        // Listen for Firebase user state
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            Task { @MainActor in
                if let user = user {
                    self.isAuthenticated = true
                    self.userEmail = user.email ?? ""
                    self.userId = user.uid                   // ✅ capture UID
                } else {
                    self.isAuthenticated = false
                    self.userEmail = ""
                    self.userId = ""
                }
            }
        }
    }

    // MARK: - Deinitializer
    deinit {
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }

    // MARK: - Login
    func login() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = AlertMessage(message: "Please enter both email and password.")
            return
        }

        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
            Task { @MainActor in
                self?.isLoading = false
                if let error = error {
                    let userFriendly = self?.parseFirebaseError(error) ?? error.localizedDescription
                    self?.alertMessage = AlertMessage(message: userFriendly)
                } else if let user = result?.user {
                    self?.isAuthenticated = true
                    self?.userEmail = user.email ?? ""
                    self?.userId = user.uid                  // ✅ save UID on successful login
                }
            }
        }
    }

    // MARK: - Register
    func register() {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = AlertMessage(message: "Email and password required.")
            return
        }

        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            Task { @MainActor in
                self?.isLoading = false
                if let error = error {
                    let userFriendly = self?.parseFirebaseError(error) ?? error.localizedDescription
                    self?.alertMessage = AlertMessage(message: userFriendly)
                } else if let user = result?.user {
                    self?.isAuthenticated = true
                    self?.userEmail = user.email ?? ""
                    self?.userId = user.uid                  // ✅ capture UID for new registration
                }
            }
        }
    }

    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            email = ""
            password = ""
            userEmail = ""
            userId = ""                                     // ✅ clear UID
        } catch {
            alertMessage = AlertMessage(message: "Failed to sign out. Please try again.")
        }
    }

    // MARK: - Reset Password
    func resetPassword() {
        guard !email.isEmpty else {
            alertMessage = AlertMessage(message: "Please enter your email address.")
            return
        }

        isLoading = true
        Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
            Task { @MainActor in
                self?.isLoading = false
                if let error = error {
                    let userFriendly = self?.parseFirebaseError(error) ?? error.localizedDescription
                    self?.alertMessage = AlertMessage(message: userFriendly)
                } else {
                    self?.alertMessage = AlertMessage(message: "Password reset email sent successfully.")
                }
            }
        }
    }

    // MARK: - Firebase Error Parser
    private func parseFirebaseError(_ error: Error) -> String {
        let nsError = error as NSError
        if let code = AuthErrorCode(rawValue: nsError.code) {
            switch code {
            case .invalidEmail:
                return "The email address is badly formatted."
            case .wrongPassword:
                return "Your password is incorrect. Please try again."
            case .userNotFound:
                return "No account found with this email address."
            case .networkError:
                return "Network error. Please check your internet connection."
            case .userDisabled:
                return "This account has been disabled. Contact support."
            case .tooManyRequests:
                return "Too many attempts. Please wait a moment and try again."
            case .invalidCredential:
                return "Invalid credentials. Please check your details."
            case .operationNotAllowed:
                return "This sign-in method is disabled for this project."
            case .emailAlreadyInUse:
                return "This email is already registered. Try signing in instead."
            default:
                return nsError.localizedDescription
            }
        } else {
            return error.localizedDescription
        }
    }
}

