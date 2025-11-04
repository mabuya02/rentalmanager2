//
//  RegisterView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI

struct RegisterView: View {
    @StateObject private var viewModel = AuthViewModel()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            LinearGradient(colors: [.white, .blue.opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()

            VStack(spacing: 25) {
                Spacer(minLength: 40)

                Image(systemName: "person.crop.circle.badge.plus.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.blue.opacity(0.8))

                Text("Create Account")
                    .font(.title2)
                    .bold()

                VStack(spacing: 16) {
                    TextField("Email address", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)

                    SecureField("Password", text: $viewModel.password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: viewModel.register) {
                    Text(viewModel.isLoading ? "Creating Account..." : "Register")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                        .shadow(color: .blue.opacity(0.3), radius: 5, y: 3)
                        .padding(.horizontal)
                }
                .disabled(viewModel.isLoading)

                Button("Already have an account? Login") {
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
        .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
            DashboardView(viewModel: viewModel)
        }
        .alert(item: $viewModel.alertMessage) { alert in
            Alert(title: Text("Notice"), message: Text(alert.message), dismissButton: .default(Text("OK")))
        }
    }
}


