//
//  NewMaintenanceRequestView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//
import SwiftUI

struct NewMaintenanceRequestView: View {
    @ObservedObject var authVM: AuthViewModel
    @ObservedObject var maintenanceVM: MaintenanceViewModel

    @Environment(\.dismiss) var dismiss
    @State private var title = ""
    @State private var description = ""
    @State private var isSubmitting = false
    @State private var showSuccess = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.05), .white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                // MARK: Header
                VStack(spacing: 8) {
                    Image(systemName: "wrench.and.screwdriver.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.blue)
                    Text("New Maintenance Request")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Text("Submit a request for any repair or service issue")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top, 20)

                // MARK: Input Card
                VStack(alignment: .leading, spacing: 16) {
                    Text("Request Details")
                        .font(.headline)

                    VStack(alignment: .leading, spacing: 12) {
                        TextField("Enter title (e.g. Broken Tap)", text: $title)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)

                        TextField("Describe the issue (e.g. kitchen tap leaking)...",
                                  text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)
                .padding(.horizontal)

                Spacer()

                // MARK: Submit Button
                Button {
                    submitRequest()
                } label: {
                    HStack {
                        if isSubmitting {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Image(systemName: "paperplane.fill")
                            Text("Submit Request")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background((title.isEmpty || description.isEmpty) ? Color.gray.opacity(0.4) : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .shadow(color: Color.blue.opacity(0.25), radius: 6, y: 4)
                    .padding(.horizontal)
                }
                .disabled(title.isEmpty || description.isEmpty || isSubmitting)

                Spacer(minLength: 30)
            }
            .overlay(
                // ✅ Success Banner
                VStack {
                    if showSuccess {
                        HStack {
                            Image(systemName: "checkmark.circle.fill")
                            Text("Request Submitted Successfully")
                                .fontWeight(.medium)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(radius: 3)
                        .padding(.horizontal)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
                .animation(.easeInOut, value: showSuccess)
            )
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                        .foregroundColor(.blue)
                }
            }
        }
    }

    // MARK: - Logic
    private func submitRequest() {
        guard let user = LocalStorageService.shared.fetchAllUsers()
            .first(where: { $0.email.lowercased() == authVM.userEmail.lowercased() }) else {
            return
        }

        isSubmitting = true

        let newRequest = MaintenanceRequest(
            id: UUID().uuidString,
            userId: user.id,
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: description.trimmingCharacters(in: .whitespacesAndNewlines),
            status: "pending",
            createdAt: ISO8601DateFormatter().string(from: Date())
        )

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            maintenanceVM.addRequest(newRequest)
            isSubmitting = false
            withAnimation {
                showSuccess = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    showSuccess = false
                    dismiss()
                }
            }
        }
    }
}
