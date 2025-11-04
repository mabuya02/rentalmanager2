//
//  ForgotPasswordView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI

struct ForgotPasswordView: View {
    @ObservedObject var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue.opacity(0.1)],
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer(minLength: 60)

                Image(systemName: "envelope.badge.fill")
                    .resizable()
                    .frame(width: 80, height: 65)
                    .foregroundColor(.blue.opacity(0.8))

                Text("Reset Password")
                    .font(.title2)
                    .bold()

                Text("Enter your registered email address and we’ll send you a link to reset your password.")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                TextField("Email address", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .textInputAutocapitalization(.never)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .padding(.horizontal)

                Button(action: {
                    viewModel.resetPassword()
                }) {
                    Text(viewModel.isLoading ? "Sending..." : "Send Reset Link")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .blue.opacity(0.3), radius: 5, y: 3)
                        .padding(.horizontal)
                }
                .disabled(viewModel.isLoading)

                Button("Back to Login") {
                    dismiss()
                }
                .font(.footnote)
                .foregroundColor(.blue)

                Spacer()
            }

            if viewModel.isLoading {
                ProgressView("Please wait...")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
            }
        }
        .alert(item: $viewModel.alertMessage) { alert in
            Alert(title: Text("Notice"),
                  message: Text(alert.message),
                  dismissButton: .default(Text("OK")))
        }
    }
}
