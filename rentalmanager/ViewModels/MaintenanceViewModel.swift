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
}

