//
//  BillsListView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI
import FirebaseAuth

struct BillsListView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var billVM = BillViewModel()

    @State private var selectedFilter: BillFilter = .all
    @State private var selectedBill: Bill? = nil

    enum BillFilter: String, CaseIterable {
        case all = "All"
        case paid = "Paid"
        case unpaid = "Unpaid"
    }

    private let currencyFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "KES"
        formatter.minimumFractionDigits = 2
        return formatter
    }()

    private var filteredBills: [Bill] {
        switch selectedFilter {
        case .all:
            return billVM.bills
        case .paid:
            return billVM.bills.filter { $0.status.lowercased() == "paid" }
        case .unpaid:
            return billVM.bills.filter { $0.status.lowercased() == "unpaid" }
        }
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.05), .white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                // MARK: - Header
                VStack(spacing: 6) {
                    Text("Your Bills")
                        .font(.title2)
                        .fontWeight(.bold)
                    Text("View, track, and manage your payments")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.top, 10)

                // MARK: - Summary Cards (Paid & Unpaid only)
                HStack(spacing: 16) {
                    SummaryCard(title: "Unpaid",
                                value: currencyFormatter.string(from: NSNumber(value: billVM.totalUnpaid)) ?? "KES 0.00",
                                color: .orange)
                    SummaryCard(title: "Paid",
                                value: currencyFormatter.string(from: NSNumber(value: billVM.totalPaid)) ?? "KES 0.00",
                                color: .green)
                }
                .padding(.horizontal)

                // MARK: - Filter
                Picker("Filter", selection: $selectedFilter) {
                    ForEach(BillFilter.allCases, id: \.self) { filter in
                        Text(filter.rawValue).tag(filter)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // MARK: - Bills List
                if filteredBills.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "tray.fill")
                            .font(.system(size: 42))
                            .foregroundColor(.gray)
                        Text("No bills to show right now.")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 80)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(filteredBills, id: \.id) { bill in
                                BillCardView(
                                    bill: bill,
                                    formattedAmount: currencyFormatter.string(from: NSNumber(value: bill.amount)) ?? "KES 0.00"
                                )
                                .onTapGesture { selectedBill = bill }
                                .transition(.opacity.combined(with: .move(edge: .bottom)))
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 80)
                    }
                    .animation(.easeInOut(duration: 0.3), value: selectedFilter)
                    .animation(.easeInOut(duration: 0.3), value: billVM.bills.count)
                }
            }
        }
        .onAppear {
            if let user = Auth.auth().currentUser {
                billVM.loadBills(for: user.uid)
            } else {
                let email = authVM.userEmail
                let users = LocalStorageService.shared.fetchAllUsers()
                if let match = users.first(where: { $0.email.lowercased() == email.lowercased() }) {
                    billVM.loadBills(for: match.id)
                }
            }
        }
        .sheet(item: $selectedBill) { bill in
            BillDetailModal(bill: bill)
        }
    }
}

// MARK: - Summary Card
private struct SummaryCard: View {
    var title: String
    var value: String
    var color: Color

    var body: some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(14)
        .shadow(color: .gray.opacity(0.15), radius: 6, y: 4)
    }
}

// MARK: - Bill Card
private struct BillCardView: View {
    var bill: Bill
    var formattedAmount: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(bill.type.capitalized)
                    .font(.headline)
                Spacer()
                StatusBadge(status: bill.status)
            }

            Text("Due: \(bill.dueDateFormatted)")
                .font(.caption)
                .foregroundColor(.gray)

            HStack {
                Text(formattedAmount)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(18)
        .shadow(color: .gray.opacity(0.15), radius: 8, y: 4)
    }
}

// MARK: - Status Badge
private struct StatusBadge: View {
    var status: String

    private var color: Color {
        switch status.lowercased() {
        case "paid": return .green
        case "unpaid": return .red
        default: return .gray
        }
    }

    var body: some View {
        Text(status.capitalized)
            .font(.caption)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(color.opacity(0.15))
            .foregroundColor(color)
            .cornerRadius(8)
    }
}

