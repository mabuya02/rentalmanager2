//
//  PaymentsListView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI
import FirebaseAuth

struct PaymentsListView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var paymentVM = PaymentViewModel()

    // MARK: - Filter
    @State private var selectedMethod: String = "All"
    private let methods = ["All", "M-Pesa", "Bank", "Card"]

    // MARK: - Filtered Payments
    private var filteredPayments: [Payment] {
        switch selectedMethod.lowercased() {
        case "m-pesa":
            return paymentVM.payments.filter { $0.method.lowercased() == "m-pesa" }
        case "bank":
            return paymentVM.payments.filter { $0.method.lowercased() == "bank" }
        case "card":
            return paymentVM.payments.filter { $0.method.lowercased() == "card" }
        default:
            return paymentVM.payments
        }
    }

    // MARK: - View
    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(colors: [Color.blue.opacity(0.05), .white],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()

                VStack(spacing: 16) {
                    // MARK: Header
                    VStack(spacing: 4) {
                        Text("Your Payments")
                            .font(.title2)
                            .fontWeight(.bold)
                        Text("Track and review all completed transactions")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 10)

                    // MARK: Summary Cards
                    HStack(spacing: 16) {
                        SummaryCard(title: "Total Paid",
                                    value: "KES \(paymentVM.totalPaid.formatted(.number.precision(.fractionLength(0))))",
                                    color: .green)
                        SummaryCard(title: "Transactions",
                                    value: "\(paymentVM.payments.count)",
                                    color: .blue)
                    }
                    .padding(.horizontal)

                    // MARK: Filter
                    Picker("Method", selection: $selectedMethod) {
                        ForEach(methods, id: \.self) { method in
                            Text(method).tag(method)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    // MARK: Payment List
                    if filteredPayments.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "creditcard.trianglebadge.exclamationmark.fill")
                                .font(.system(size: 46))
                                .foregroundColor(.gray)
                            Text("No payments to show.")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 80)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                ForEach(filteredPayments, id: \.id) { payment in
                                    PaymentCardView(payment: payment)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 50)
                        }
                    }

                    Spacer()
                }
            }
            .onAppear {
                if let user = Auth.auth().currentUser {
                    paymentVM.loadPayments(forUserId: user.uid)
                } else {
                    paymentVM.loadPayments(forEmail: authVM.userEmail)
                }
            }
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
        .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)
    }
}

// MARK: - Payment Card
private struct PaymentCardView: View {
    var payment: Payment

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label(payment.method.capitalized,
                      systemImage: payment.method.lowercased() == "m-pesa"
                      ? "phone.fill"
                      : payment.method.lowercased() == "bank"
                        ? "building.columns.fill"
                        : "creditcard.fill")
                    .font(.headline)
                    .foregroundColor(colorForMethod(payment.method))
                Spacer()
                Text(payment.status.capitalized)
                    .font(.caption)
                    .foregroundColor(payment.status.lowercased() == "successful" ? .green : .orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(payment.status.lowercased() == "successful"
                                ? Color.green.opacity(0.15)
                                : Color.orange.opacity(0.15))
                    .cornerRadius(8)
            }

            Text("KES \(Int(payment.amount)) • \(payment.dateFormatted)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Ref: \(payment.reference)")
                .font(.caption2)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.15), radius: 6, y: 3)
        .onTapGesture { showReceipt(payment) }
    }

    private func colorForMethod(_ method: String) -> Color {
        switch method.lowercased() {
        case "m-pesa": return .green
        case "bank": return .blue
        case "card": return .purple
        default: return .gray
        }
    }

    private func showReceipt(_ payment: Payment) {
        let alert = UIAlertController(
            title: "Receipt",
            message: """
                     Payment of KES \(Int(payment.amount)) via \(payment.method.capitalized) was \(payment.status.lowercased()).
                     
                     Ref: \(payment.reference)
                     Date: \(payment.dateFormatted)
                     """,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Done", style: .default))
        UIApplication.topMostController()?.present(alert, animated: true)
    }
}
