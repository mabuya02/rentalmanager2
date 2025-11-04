//
//  DashboardView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI

struct DashboardView: View {
    @ObservedObject var viewModel: AuthViewModel
    @StateObject private var dashboardVM = DashboardViewModel()

    var body: some View {
        NavigationView {
            ZStack {
                // MARK: - Background
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                if dashboardVM.isLoading {
                    ProgressView("Loading your dashboard…")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .scaleEffect(1.3)
                } else {
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {

                            // MARK: - Header
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

                            // MARK: - Summary Cards
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
                                    value: "\(dashboardVM.activeMaintenanceCount)",
                                    icon: "wrench.and.screwdriver.fill",
                                    color: .blue
                                )
                            }
                            .padding(.horizontal)
                            .transition(.opacity.combined(with: .scale))

                            // MARK: - Quick Actions
                            VStack(alignment: .leading, spacing: 14) {
                                Text("Quick Actions")
                                    .font(.headline)
                                    .padding(.horizontal)

                                HStack(spacing: 16) {
                                    QuickActionButton(title: "Bills", icon: "doc.plaintext.fill", color: .orange)
                                    QuickActionButton(title: "Payments", icon: "banknote.fill", color: .green)
                                    QuickActionButton(title: "Maintenance", icon: "wrench.fill", color: .blue)
                                }
                                .padding(.horizontal)
                            }

                            Spacer(minLength: 30)

                            // MARK: - Logout
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
                        .animation(.easeInOut(duration: 0.4), value: dashboardVM.totalPayments)
                    }
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    dashboardVM.loadData(for: viewModel.userEmail)
                }
            }
        }
    }
}

//
// MARK: - DashboardCardView
//
struct DashboardCardView: View {
    var title: String
    var subtitle: String
    var value: String
    var icon: String
    var color: Color

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.headline)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer()

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(color)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 5, y: 3)
    }
}

//
// MARK: - QuickActionButton
//
struct QuickActionButton: View {
    var title: String
    var icon: String
    var color: Color

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.15))
                    .frame(width: 50, height: 50)
                Image(systemName: icon)
                    .foregroundColor(color)
                    .font(.title2)
            }
            Text(title)
                .font(.footnote)
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
    }
}

