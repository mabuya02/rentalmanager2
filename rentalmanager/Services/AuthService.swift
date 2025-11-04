//
//  AuthService.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import Foundation
import FirebaseAuth

final class AuthService {
    static let shared = AuthService()
    private init() {}

    // MARK: - Login
    func login(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "No user data found."])))
                return
            }

            // ✅ Map Firebase User -> Local User model
            let user = User(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ?? "Tenant User",
                email: firebaseUser.email ?? "",
                phone: "",
                apartmentNumber: "",
                propertyName: "",
                leaseStatus: "Active"
            )

            completion(.success(user))
        }
    }

    // MARK: - Register
    func register(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let firebaseUser = result?.user else {
                completion(.failure(NSError(domain: "AuthError", code: -1, userInfo: [NSLocalizedDescriptionKey: "User registration failed."])))
                return
            }

            // ✅ Map Firebase User -> Local User model
            let user = User(
                id: firebaseUser.uid,
                name: firebaseUser.displayName ?? "New Tenant",
                email: firebaseUser.email ?? "",
                phone: "",
                apartmentNumber: "",
                propertyName: "",
                leaseStatus: "Active"
            )

            completion(.success(user))
        }
    }

    // MARK: - Password Reset
    func resetPassword(email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    // MARK: - Logout
    func logout() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("❌ Error signing out: \(error.localizedDescription)")
        }
    }
}

