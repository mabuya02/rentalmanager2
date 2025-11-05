//
//  MaintenanceDetailView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI

struct MaintenanceDetailView: View {
    var request: MaintenanceRequest
    @ObservedObject var maintenanceVM: MaintenanceViewModel
    @Environment(\.dismiss) var dismiss
    @State private var showResolvedBanner = false

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: iconForStatus(request.status))
                .font(.system(size: 60))
                .foregroundColor(colorForStatus(request.status))
                .padding(.top, 20)

            VStack(alignment: .leading, spacing: 12) {
                MaintenanceInfoRow(label: "Title", value: request.title)
                MaintenanceInfoRow(label: "Description", value: request.description)
                MaintenanceInfoRow(label: "Status", value: request.status.capitalized)
                MaintenanceInfoRow(label: "Date Submitted", value: request.createdAtFormatted)
                MaintenanceInfoRow(label: "Request ID", value: request.id)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)

            if request.status.lowercased() != "resolved" {
                Button {
                    markAsResolved()
                } label: {
                    Text("Mark as Resolved")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(12)
                        .shadow(color: .green.opacity(0.3), radius: 5, y: 3)
                }
                .padding(.horizontal)
            }

            Spacer()
        }
        .padding()
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Request Details")
        .overlay(
            VStack {
                if showResolvedBanner {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Marked as Resolved")
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
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showResolvedBanner = false
                                dismiss()
                            }
                        }
                    }
                }
                Spacer()
            }
            .padding(.bottom, 30)
        )
    }

    private func markAsResolved() {
        maintenanceVM.markAsResolved(request)
        withAnimation { showResolvedBanner = true }
    }

    private func colorForStatus(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "in progress": return .blue
        case "resolved": return .green
        default: return .gray
        }
    }

    private func iconForStatus(_ status: String) -> String {
        switch status.lowercased() {
        case "pending": return "clock"
        case "in progress": return "hammer.fill"
        case "resolved": return "checkmark.circle.fill"
        default: return "questionmark.circle"
        }
    }
}

// MARK: - Unique Row Type (avoid name clash)
private struct MaintenanceInfoRow: View {
    var label: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}

