//
//  LocalStorageService.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

/// Centralized local data manager with full CRUD for demo persistence
final class LocalStorageService {

    // MARK: - Singleton
    static let shared = LocalStorageService()
    private init() {
        copyInitialDataIfNeeded()
    }

    // MARK: - File management paths
    private var documentsURL: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }

    // MARK: - List of data files
    private let dataFiles = [
        "users",
        "bills",
        "payments",
        "maintenanceRequests",
        "notifications"
    ]

    // MARK: - Copy initial JSON data to Documents directory (once)
    private func copyInitialDataIfNeeded() {
        for file in dataFiles {
            let destinationURL = documentsURL.appendingPathComponent("\(file).json")

            if !FileManager.default.fileExists(atPath: destinationURL.path) {
                if let bundleURL = Bundle.main.url(forResource: file, withExtension: "json") {
                    do {
                        try FileManager.default.copyItem(at: bundleURL, to: destinationURL)
                        print("✅ Copied \(file).json to Documents directory.")
                    } catch {
                        print("❌ Failed to copy \(file).json: \(error.localizedDescription)")
                    }
                } else {
                    print("⚠️ Missing \(file).json in app bundle.")
                }
            }
        }
    }

    // MARK: - Get file URL
    private func fileURL(for filename: String) -> URL {
        documentsURL.appendingPathComponent("\(filename).json")
    }

    // MARK: - Generic JSON loader
    private func loadJSON<T: Decodable>(_ type: T.Type, from filename: String) -> T {
        let url = fileURL(for: filename)
        do {
            let data = try Data(contentsOf: url)
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            print("⚠️ Could not decode \(filename).json: \(error.localizedDescription)")
            if let empty = [] as? T { return empty }
            fatalError("❌ Failed to load \(filename).json and cannot create fallback for type \(T.self)")
        }
    }

    // MARK: - Generic JSON writer
    private func saveJSON<T: Encodable>(_ data: T, to filename: String) {
        let url = fileURL(for: filename)
        do {
            let encoded = try JSONEncoder().encode(data)
            let jsonData = try JSONSerialization.data(
                withJSONObject: try JSONSerialization.jsonObject(with: encoded),
                options: .prettyPrinted
            )
            try jsonData.write(to: url, options: .atomic)
        } catch {
            print("❌ Failed to save \(filename).json: \(error.localizedDescription)")
        }
    }

    // =====================================================
    // MARK: - CRUD OPERATIONS
    // =====================================================

    // MARK: - Fetch
    func fetchAllUsers() -> [User] {
        loadJSON([User].self, from: "users")
    }

    func fetchBills(for userId: String) -> [Bill] {
        loadJSON([Bill].self, from: "bills").filter { $0.userId == userId }
    }

    func fetchPayments(for userId: String) -> [Payment] {
        loadJSON([Payment].self, from: "payments").filter { $0.userId == userId }
    }

    func fetchMaintenanceRequests(for userId: String) -> [MaintenanceRequest] {
        loadJSON([MaintenanceRequest].self, from: "maintenanceRequests").filter { $0.userId == userId }
    }

    func fetchNotifications(for userId: String) -> [NotificationItem] {
        loadJSON([NotificationItem].self, from: "notifications").filter { $0.userId == userId }
    }

    // MARK: - Add
    func add<T: Codable & Identifiable>(_ item: T, to filename: String) where T.ID == String {
        var items = loadJSON([T].self, from: filename)
        items.append(item)
        DispatchQueue.global(qos: .background).async {
            self.saveJSON(items, to: filename)
        }
        print("✅ Added \(T.self) item to \(filename).json")
    }

    // MARK: - Update
    func update<T: Codable & Identifiable>(_ item: T, in filename: String) where T.ID == String {
        var items = loadJSON([T].self, from: filename)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            DispatchQueue.global(qos: .background).async {
                self.saveJSON(items, to: filename)
            }
            print("✅ Updated \(T.self) item \(item.id) in \(filename).json")
        } else {
            print("⚠️ No matching \(T.self) found for update in \(filename).json")
        }
    }

    // MARK: - Delete
    func delete<T: Codable & Identifiable>(_ type: T.Type, id: String, from filename: String) where T.ID == String {
        var items = loadJSON([T].self, from: filename)
        items.removeAll { $0.id == id }
        DispatchQueue.global(qos: .background).async {
            self.saveJSON(items, to: filename)
        }
        print("🗑️ Deleted \(T.self) item \(id) from \(filename).json")
    }
}

