//
//  MaintenanceViewModel.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import Foundation
import Combine

@MainActor
final class MaintenanceViewModel: ObservableObject {
    @Published var requests: [MaintenanceRequest] = []
    private let storage = LocalStorageService.shared

    func loadRequests(for userId: String) {
        requests = storage.fetchMaintenanceRequests(for: userId)
    }

    func addRequest(_ request: MaintenanceRequest) {
        storage.add(request, to: "maintenanceRequests")
        requests.append(request)
    }

    func markAsResolved(_ request: MaintenanceRequest) {
        var updated = request
        updated.status = "Resolved"            // now allowed because status is var

        // Persist update (do not append a duplicate)
        storage.update(updated, in: "maintenanceRequests")

        // Refresh in-memory list for this user
        requests = storage.fetchMaintenanceRequests(for: request.userId)

        print("✅ Maintenance request \(request.id) marked as resolved.")
    }
}

