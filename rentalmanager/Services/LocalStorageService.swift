//
//  LocalStorageService.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 04/11/2025.
//

import Foundation

/// Centralized local data manager for demo persistence
final class LocalStorageService {

    // MARK: - Singleton
    static let shared = LocalStorageService()
    private init() {
        print("📂 LocalStorageService initialized. Using explicit Data/ folder for JSON.")
    }

    // MARK: - File management paths

    /// Absolute path to your Data folder (local demo use only)
    private var dataFolderURL: URL {
        let path = "/Users/mabuya/Developer/rentalmanager/rentalmanager/Data"
        let url = URL(fileURLWithPath: path, isDirectory: true)

        if FileManager.default.fileExists(atPath: url.path) {
            print("📁 Using Data folder at: \(url.path)")
            return url
        } else {
            fatalError("❌ Data folder not found at \(url.path). Please verify the path.")
        }
    }

    // MARK: - Generic JSON Loader
    private func loadJSON<T: Decodable>(_ type: T.Type, from filename: String) -> T {
        let url = dataFolderURL.appendingPathComponent("\(filename).json")

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(T.self, from: data)
            print("✅ Loaded \(filename).json successfully from Data folder.")
            return decoded
        } catch {
            print("❌ Failed to read \(filename).json: \(error.localizedDescription)")
            if let empty = [] as? T { return empty }
            fatalError("❌ Could not decode \(filename).json and no fallback available for \(T.self)")
        }
    }

    // MARK: - Generic JSON Writer (optional demo use)
    private func saveJSON<T: Encodable>(_ data: T, to filename: String) {
        let url = dataFolderURL.appendingPathComponent("\(filename).json")
        do {
            let encoded = try JSONEncoder().encode(data)
            let jsonData = try JSONSerialization.data(
                withJSONObject: try JSONSerialization.jsonObject(with: encoded),
                options: .prettyPrinted
            )
            try jsonData.write(to: url, options: .atomic)
            print("💾 Saved \(filename).json to \(url.path)")
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

    // MARK: - Add / Update / Delete (optional demo write support)
    func add<T: Codable & Identifiable>(_ item: T, to filename: String) where T.ID == String {
        var items = loadJSON([T].self, from: filename)
        items.append(item)
        saveJSON(items, to: filename)
        print("✅ Added \(T.self) item to \(filename).json")
    }

    func update<T: Codable & Identifiable>(_ item: T, in filename: String) where T.ID == String {
        var items = loadJSON([T].self, from: filename)
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item
            saveJSON(items, to: filename)
            print("✅ Updated \(T.self) item \(item.id) in \(filename).json")
        } else {
            print("⚠️ No matching \(T.self) found for update in \(filename).json")
        }
    }

    func delete<T: Codable & Identifiable>(_ type: T.Type, id: String, from filename: String) where T.ID == String {
        var items = loadJSON([T].self, from: filename)
        items.removeAll { $0.id == id }
        saveJSON(items, to: filename)
        print("🗑️ Deleted \(T.self) item \(id) from \(filename).json")
    }
}

