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

    var body: some View {
        NavigationView {
            VStack {
                if paymentVM.payments.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "creditcard.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.gray)
                        Text("No payments yet.")
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 100)
                } else {
                    List(paymentVM.payments, id: \.id) { payment in
                        NavigationLink(destination: PaymentDetailView(payment: payment)) {
                            HStack {
                                VStack(alignment: .leading, spacing: 6) {
                                    Text(payment.method.capitalized)
                                        .font(.headline)
                                    Text("Date: \(payment.dateFormatted)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                VStack(alignment: .trailing, spacing: 4) {
                                    Text("KES \(Int(payment.amount))")
                                        .fontWeight(.bold)
                                        .foregroundColor(.green)
                                    Text(payment.status.capitalized)
                                        .font(.caption)
                                        .foregroundColor(payment.status.lowercased() == "successful" ? .green : .gray)
                                }
                            }
                            .padding(.vertical, 6)
                        }
                    }
                    .listStyle(.insetGrouped)
                }

                Spacer()
            }
            .navigationTitle("Payments")
            .onAppear {
                if let user = Auth.auth().currentUser {
                    // ✅ Prefer UID path (fast path)
                    paymentVM.loadPayments(forUserId: user.uid)
                } else {
                    // ✅ Fall back to email -> local users.json ID mapping
                    paymentVM.loadPayments(forEmail: authVM.userEmail)
                }
            }
        }
    }
}

