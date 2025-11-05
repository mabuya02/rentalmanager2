//
//  PaymentDetailView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI

struct PaymentDetailView: View {
    let payment: Payment

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    Image(systemName: payment.method.lowercased() == "mpesa" ? "phone.fill" : "building.columns.fill")
                        .font(.system(size: 60))
                        .foregroundColor(payment.method.lowercased() == "mpesa" ? .green : .blue)

                    Text("KES \(Int(payment.amount))")
                        .font(.system(size: 32, weight: .bold))

                    Text(payment.status.capitalized)
                        .foregroundColor(payment.status.lowercased() == "successful" ? .green : .orange)
                        .font(.headline)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                .shadow(color: .gray.opacity(0.2), radius: 8, y: 4)

                VStack(spacing: 12) {
                    PaymentDetailRow(label: "Payment ID", value: payment.id)
                    PaymentDetailRow(label: "Method", value: payment.method.capitalized)
                    PaymentDetailRow(label: "Reference", value: payment.reference)
                    PaymentDetailRow(label: "Date", value: payment.dateFormatted)
                    PaymentDetailRow(label: "Status", value: payment.status.capitalized)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.1), radius: 6, y: 3)

                Button(action: showReceipt) {
                    Label("Download Receipt", systemImage: "arrow.down.doc.fill")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Payment Details")
    }

    private func showReceipt() {
        let alert = UIAlertController(
            title: "Receipt Downloaded",
            message: "Your payment receipt for \(payment.reference) has been generated successfully.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        UIApplication.topMostController()?.present(alert, animated: true)
    }
}

private struct PaymentDetailRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
}

