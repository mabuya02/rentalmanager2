//
//  DashboardView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI
import FirebaseAuth

struct DashboardView: View {
    @ObservedObject var viewModel: AuthViewModel
    @StateObject private var dashboardVM = DashboardViewModel()

    // MARK: - Sheet triggers
    @State private var showBills = false
    @State private var showPayments = false
    @State private var showMaintenance = false
    @State private var showProfile = false
    @State private var showNotifications = false

    @State private var selectedPayment: Payment?

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.white, Color.blue.opacity(0.03)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                if dashboardVM.isLoading {
                    ProgressView("Loading dashboard…")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.3)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(alignment: .leading, spacing: 24) {

                            // MARK: - Greeting Header
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(greetingMessage())
                                        .font(.title3)
                                        .fontWeight(.semibold)
                                    Text(viewModel.userEmail)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                HStack(spacing: 14) {
                                    Button { showNotifications = true } label: {
                                        Circle()
                                            .fill(Color(.systemGray6))
                                            .frame(width: 38, height: 38)
                                            .overlay(
                                                Image(systemName: "bell.fill")
                                                    .foregroundColor(.blue)
                                                    .font(.system(size: 18, weight: .medium))
                                            )
                                    }

                                    Button { showProfile = true } label: {
                                        Circle()
                                            .fill(Color(.systemGray6))
                                            .frame(width: 38, height: 38)
                                            .overlay(
                                                Image(systemName: "person.crop.circle.fill")
                                                    .resizable()
                                                    .foregroundColor(.blue)
                                                    .frame(width: 32, height: 32)
                                            )
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.top, 8)

                            // MARK: - Horizontal Cards
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 16) {
                                    DashboardCardHorizontal(
                                        title: "Total Payments",
                                        value: dashboardVM.totalPayments,
                                        subtitle: "Rent + utilities paid",
                                        icon: "creditcard.fill",
                                        gradient: LinearGradient(colors: [Color.green.opacity(0.3), .white], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        color: .green
                                    )

                                    DashboardCardHorizontal(
                                        title: "Maintenance",
                                        value: dashboardVM.activeMaintenanceCount,
                                        subtitle: "Active requests",
                                        icon: "wrench.and.screwdriver.fill",
                                        gradient: LinearGradient(colors: [Color.blue.opacity(0.3), .white], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        color: .blue
                                    )

                                    DashboardCardHorizontal(
                                        title: "Bills Due",
                                        value: dashboardVM.totalUnpaidBills,
                                        subtitle: "Total Due: \(dashboardVM.totalDueAmount)",
                                        icon: "doc.text.fill",
                                        gradient: LinearGradient(colors: [Color.orange.opacity(0.3), .white], startPoint: .topLeading, endPoint: .bottomTrailing),
                                        color: .orange
                                    )
                                }
                                .padding(.horizontal)
                            }

                            // MARK: - Quick Actions
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Quick Actions")
                                    .font(.headline)
                                    .padding(.horizontal)

                                HStack(spacing: 16) {
                                    Button { showBills = true } label: {
                                        QuickActionButton(title: "Pay Bills",
                                                          icon: "banknote.fill",
                                                          color: .green)
                                    }

                                    Button { showMaintenance = true } label: {
                                        QuickActionButton(title: "New Request",
                                                          icon: "plus.circle.fill",
                                                          color: .blue)
                                    }
                                }
                                .padding(.horizontal)
                            }

                            // MARK: - Recent Bills Paid
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Recent Bills Paid")
                                    .font(.headline)
                                    .padding(.horizontal)

                                if dashboardVM.recentPayments.isEmpty {
                                    Text("No recent payments found.")
                                        .foregroundColor(.gray)
                                        .font(.subheadline)
                                        .padding(.horizontal)
                                } else {
                                    VStack(spacing: 10) {
                                        ForEach(dashboardVM.recentPayments.prefix(10)) { p in
                                            Button {
                                                selectedPayment = p
                                            } label: {
                                                HStack {
                                                    VStack(alignment: .leading, spacing: 4) {
                                                        Text(p.method.capitalized)
                                                            .font(.headline)
                                                        Text(p.dateFormatted)
                                                            .font(.caption)
                                                            .foregroundColor(.gray)
                                                    }
                                                    Spacer()
                                                    VStack(alignment: .trailing, spacing: 2) {
                                                        Text(formatKES(p.amount))
                                                            .fontWeight(.semibold)
                                                            .foregroundColor(.blue)
                                                        Text(p.status.capitalized)
                                                            .font(.caption)
                                                            .foregroundColor(p.status.lowercased() == "paid" ? .green : .orange)
                                                    }
                                                }
                                                .padding()
                                                .background(Color.white)
                                                .cornerRadius(16)
                                                .shadow(color: .gray.opacity(0.07), radius: 5, y: 3)
                                                .padding(.horizontal)
                                            }
                                        }
                                    }
                                }
                            }

                            Spacer(minLength: 80)
                        }
                        .padding(.top, 12)
                    }
                }
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    dashboardVM.loadData(forUserId: user.uid)
                } else {
                    dashboardVM.loadData(forEmail: viewModel.userEmail)
                }
            }
            // MARK: - Sheets
            .sheet(isPresented: $showBills) { BillsListView(authVM: viewModel) }
            .sheet(isPresented: $showPayments) { PaymentsListView(authVM: viewModel) }
            .sheet(isPresented: $showMaintenance) { NewMaintenanceRequestView(authVM: viewModel, maintenanceVM: MaintenanceViewModel()) }
            .sheet(isPresented: $showProfile) { ProfileView(authVM: viewModel) }
            .sheet(isPresented: $showNotifications) { NotificationsListView(authVM: viewModel) }
            .sheet(item: $selectedPayment) { payment in
                PaymentDetailModal(payment: payment)
            }
        }
    }

    private func formatKES(_ amount: Double) -> String {
        let nf = NumberFormatter()
        nf.numberStyle = .decimal
        nf.groupingSeparator = ","
        return "KES " + (nf.string(from: NSNumber(value: amount)) ?? "\(amount)")
    }

    private func greetingMessage() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good Morning, Mabuya ☀️"
        case 12..<17: return "Good Afternoon, Mabuya 🌤️"
        default: return "Good Evening, Mabuya 🌙"
        }
    }
}

