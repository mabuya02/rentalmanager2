import SwiftUI
import FirebaseAuth

struct MaintenanceListView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var maintenanceVM = MaintenanceViewModel()
    @State private var showNewRequest = false
    @State private var selectedRequest: MaintenanceRequest? = nil
    @State private var selectedStatus: String = "All"

    private let statusFilters = ["All", "Pending", "In Progress", "Resolved"]

    private var filteredRequests: [MaintenanceRequest] {
        maintenanceVM.requests.filter { request in
            // Normalize to handle hyphens, spaces, lowercase, etc.
            let normalizedStatus = request.status
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: " ", with: "")
                .lowercased()
            let selectedNormalized = selectedStatus
                .replacingOccurrences(of: "-", with: "")
                .replacingOccurrences(of: " ", with: "")
                .lowercased()
            return selectedStatus == "All" || normalizedStatus == selectedNormalized
        }
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            LinearGradient(colors: [Color.blue.opacity(0.05), .white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // MARK: Header
                VStack(spacing: 6) {
                    Text("Maintenance Requests")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("Track and manage your repair or service requests")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)

                // MARK: Status Filter with Counts
                Picker("Status", selection: $selectedStatus) {
                    ForEach(statusFilters, id: \.self) { status in
                        let count = maintenanceVM.requests.filter {
                            let normalized = $0.status
                                .replacingOccurrences(of: "-", with: "")
                                .replacingOccurrences(of: " ", with: "")
                                .lowercased()
                            let normalizedTag = status
                                .replacingOccurrences(of: "-", with: "")
                                .replacingOccurrences(of: " ", with: "")
                                .lowercased()
                            return status == "All" || normalized == normalizedTag
                        }.count
                        Text("\(status) (\(count))").tag(status)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                .padding(.top, 6)

                // MARK: List or Empty State
                Group {
                    if filteredRequests.isEmpty {
                        VStack(spacing: 14) {
                            Spacer()
                            Image(systemName: "wrench.and.screwdriver.fill")
                                .font(.system(size: 54))
                                .foregroundColor(.gray.opacity(0.7))
                            Text("No \(selectedStatus.lowercased()) requests.")
                                .foregroundColor(.gray)
                                .font(.callout)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredRequests, id: \.id) { request in
                                    MaintenanceCardView(request: request)
                                        .onTapGesture { selectedRequest = request }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 80)
                        }
                    }
                }
                .animation(.easeInOut, value: filteredRequests.map { $0.id })
            }

            // MARK: Floating Action Button
            Button {
                showNewRequest = true
            } label: {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 60))
                    .foregroundColor(.blue)
                    .shadow(color: .blue.opacity(0.3), radius: 8, y: 4)
            }
            .padding()
        }
        .sheet(isPresented: $showNewRequest) {
            NewMaintenanceRequestView(authVM: authVM, maintenanceVM: maintenanceVM)
        }
        .sheet(item: $selectedRequest) { request in
            MaintenanceDetailView(request: request, maintenanceVM: maintenanceVM)
        }
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
    }
}

// MARK: - Maintenance Card
private struct MaintenanceCardView: View {
    var request: MaintenanceRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(request.title, systemImage: iconForStatus(request.status))
                    .font(.headline)
                    .foregroundColor(colorForStatus(request.status))
                Spacer()
                Text(request.status.capitalized.replacingOccurrences(of: "-", with: " "))
                    .font(.caption)
                    .foregroundColor(colorForStatus(request.status))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(colorForStatus(request.status).opacity(0.15))
                    .cornerRadius(8)
            }

            Text(request.description)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineLimit(2)

            Text("Date: \(request.createdAtFormatted)")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)
    }

    private func colorForStatus(_ status: String) -> Color {
        switch status.lowercased() {
        case "pending": return .orange
        case "in-progress", "in progress": return .blue
        case "resolved": return .green
        default: return .gray
        }
    }

    private func iconForStatus(_ status: String) -> String {
        switch status.lowercased() {
        case "pending": return "clock"
        case "in-progress", "in progress": return "hammer.fill"
        case "resolved": return "checkmark.circle.fill"
        default: return "questionmark.circle"
        }
    }
}

