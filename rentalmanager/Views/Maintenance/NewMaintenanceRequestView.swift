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

    var body: some View {
        NavigationStack {
            Form {
                Section("Request Info") {
                    TextField("Title", text: $title)
                    TextField("Description", text: $description, axis: .vertical)
                        .lineLimit(3...5)
                }

                Section {
                    Button {
                        submitRequest()
                    } label: {
                        if isSubmitting {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Submit Request")
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
            .navigationTitle("New Request")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
        }
    }

    private func submitRequest() {
        guard let user = LocalStorageService.shared.fetchAllUsers()
            .first(where: { $0.email.lowercased() == authVM.userEmail.lowercased() }) else {
            return
        }

        isSubmitting = true
        let newRequest = MaintenanceRequest(
            id: UUID().uuidString,
            userId: user.id,
            title: title,
            description: description,
            status: "Pending",
            createdAt: ISO8601DateFormatter().string(from: Date())
        )


        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            maintenanceVM.addRequest(newRequest)
            isSubmitting = false
            dismiss()
        }
    }
}

