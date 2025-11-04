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

    // Local navigation triggers (for sheets or modals)
    @State private var showBills = false
    @State private var showPayments = false
    @State private var showMaintenance = false
    @State private var showProfile = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.1), .white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            if dashboardVM.isLoading {
                ProgressView("Loading your dashboard…")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.3)
            } else {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {

                        // MARK: Header
                        HStack(spacing: 16) {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .frame(width: 55, height: 55)
                                .foregroundColor(.blue)

                            VStack(alignment: .leading, spacing: 4) {
                                Text("Welcome back 👋🏽")
                                    .font(.headline)
                                Text(viewModel.userEmail)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)

                        // MARK: Summary Cards
                        VStack(spacing: 20) {
                            DashboardCardView(
                                title: "Bills Due",
                                subtitle: "Upcoming rent or water bills",
                                value: dashboardVM.totalUnpaidBills,
                                icon: "doc.text.fill",
                                color: .orange
                            )

                            DashboardCardView(
                                title: "Total Payments",
                                subtitle: "Rent + Utilities paid",
                                value: dashboardVM.totalPayments,
                                icon: "creditcard.fill",
                                color: .green
                            )

                            DashboardCardView(
                                title: "Maintenance",
                                subtitle: "Active service requests",
                                value: dashboardVM.activeMaintenanceCount,
                                icon: "wrench.and.screwdriver.fill",
                                color: .blue
                            )
                        }
                        .padding(.horizontal)

                        // MARK: Quick Actions
                        VStack(alignment: .leading, spacing: 14) {
                            Text("Quick Actions")
                                .font(.headline)
                                .padding(.horizontal)

                            HStack(spacing: 16) {
                                Button { showBills = true } label: {
                                    QuickActionButton(title: "Bills",
                                                      icon: "doc.plaintext.fill",
                                                      color: .orange)
                                }

                                Button { showPayments = true } label: {
                                    QuickActionButton(title: "Payments",
                                                      icon: "banknote.fill",
                                                      color: .green)
                                }

                                Button { showMaintenance = true } label: {
                                    QuickActionButton(title: "Maintenance",
                                                      icon: "wrench.fill",
                                                      color: .blue)
                                }

                                Button { showProfile = true } label: {
                                    QuickActionButton(title: "Profile",
                                                      icon: "person.crop.circle.fill",
                                                      color: .purple)
                                }
                            }
                            .padding(.horizontal)
                        }

                        Spacer(minLength: 30)

                        // MARK: Logout
                        Button(action: viewModel.logout) {
                            Text("Logout")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                                .shadow(color: .red.opacity(0.3), radius: 6, y: 3)
                                .padding(.horizontal)
                        }

                        Spacer(minLength: 40)
                    }
                    .padding(.top, 30)
                    .animation(.easeInOut(duration: 0.4),
                               value: dashboardVM.totalPayments)
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
        // MARK: - Sheets for navigation (instead of pushing new stacks)
        .sheet(isPresented: $showBills) {
            BillsListView(authVM: viewModel)
        }
        .sheet(isPresented: $showPayments) {
            PaymentsListView(authVM: viewModel)
        }
        .sheet(isPresented: $showMaintenance) {
            MaintenanceListView(authVM: viewModel)
        }
        .sheet(isPresented: $showProfile) {
            ProfileView(authVM: viewModel)
        }
    }
}

