//
//  MaintenanceListView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI
import FirebaseAuth

struct MaintenanceListView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var maintenanceVM = MaintenanceViewModel()
    @State private var showNewRequest = false

    var body: some View {
        VStack {
            if maintenanceVM.requests.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "wrench.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.gray)
                    Text("No maintenance requests yet.")
                        .foregroundColor(.gray)
                }
                .padding(.top, 100)
            } else {
                // ✅ Correct List initialization (no Binding)
                List(maintenanceVM.requests, id: \.id) { request in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Text(request.title)
                                .font(.headline)
                            Spacer()
                            Text(request.status.capitalized)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(statusColor(for: request.status).opacity(0.15))
                                .foregroundColor(statusColor(for: request.status))
                                .cornerRadius(8)
                        }

                        Text(request.description)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(2)

                        // ✅ Match your latest model (`createdAtFormatted`)
                        Text("Date: \(request.createdAtFormatted)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                .listStyle(.insetGrouped)
            }

            Spacer()

            Button(action: {
                showNewRequest = true
            }) {
                Label("New Request", systemImage: "plus.circle.fill")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
                    .shadow(color: .blue.opacity(0.3), radius: 5, y: 3)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Maintenance")
        .onAppear {
            if let user = Auth.auth().currentUser {
                maintenanceVM.loadRequests(for: user.uid)
            } else {
                let email = authVM.userEmail
                let users = LocalStorageService.shared.fetchAllUsers()
                if let match = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
                    maintenanceVM.loadRequests(for: match.id)
                }
            }
        }
        .sheet(isPresented: $showNewRequest) {
            NewMaintenanceRequestView(authVM: authVM, maintenanceVM: maintenanceVM)
        }
    }

    // MARK: - Helper
    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "in progress": return .blue
        case "resolved": return .green
        default: return .gray
        }
    }
}

