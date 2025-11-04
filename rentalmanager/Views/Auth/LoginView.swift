//
//  LoginView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: AuthViewModel   // ✅ Injected from ContentView
    @State private var step: LoginStep = .email
    @State private var showForgotPassword = false
    @FocusState private var focusedField: Field?

    enum Field { case email, password }
    enum LoginStep { case email, password }

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {

                // MARK: - App Icon
                Image(systemName: "house.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue.opacity(0.9))
                    .padding(.top, 120)

                Text("Welcome Back 👋🏽")
                    .font(.title2)
                    .fontWeight(.semibold)

                // MARK: - Step 1: Email
                if step == .email {
                    VStack(spacing: 16) {
                        TextField("Email address", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .focused($focusedField, equals: .email)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)

                        Button {
                            withAnimation(.easeInOut) {
                                step = .password
                                focusedField = .password
                            }
                        } label: {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(viewModel.email.isEmpty ? Color.gray : Color.blue)
                                .cornerRadius(10)
                                .shadow(color: .blue.opacity(0.3), radius: 5, y: 3)
                                .padding(.horizontal, 40)
                        }
                        .disabled(viewModel.email.isEmpty)
                    }
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }

                // MARK: - Step 2: Password
                if step == .password {
                    VStack(spacing: 18) {

                        HStack {
                            Text("Logging in as:")
                                .font(.footnote)
                                .foregroundColor(.gray)
                            Text(viewModel.email)
                                .font(.footnote)
                                .fontWeight(.medium)
                                .foregroundColor(.black)
                        }
                        .padding(.top, 10)
                        .transition(.opacity)

                        SecureField("Password", text: $viewModel.password)
                            .focused($focusedField, equals: .password)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 40)
                            .transition(.opacity.combined(with: .move(edge: .bottom)))

                        Button(action: viewModel.login) {
                            Text(viewModel.isLoading ? "Signing In ..." : "Login")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(10)
                                .shadow(color: .blue.opacity(0.3), radius: 6, y: 4)
                                .padding(.horizontal, 40)
                        }
                        .disabled(viewModel.isLoading)

                        Button("Forgot Password?") {
                            showForgotPassword = true
                        }
                        .font(.footnote)
                        .foregroundColor(.blue)
                        .padding(.top, 4)

                        Button(action: {
                            withAnimation(.easeInOut) {
                                step = .email
                                focusedField = .email
                            }
                        }) {
                            Text("Use a different email")
                                .font(.footnote)
                                .foregroundColor(.gray)
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }

                Spacer(minLength: 60)
            }
            .background(
                LinearGradient(colors: [.white, .blue.opacity(0.08)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
            )
            .onTapGesture { focusedField = nil }

            // ✅ Updated: Navigate to MainTabView on success
            .fullScreenCover(isPresented: $viewModel.isAuthenticated) {
                MainTabView(authVM: viewModel)
            }

            .sheet(isPresented: $showForgotPassword) {
                ForgotPasswordView(viewModel: viewModel)
            }

            .alert(item: $viewModel.alertMessage) { alert in
                Alert(title: Text("Notice"),
                      message: Text(alert.message),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
}

