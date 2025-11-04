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
        VStack(spacing: 20) {
            Image(systemName: "banknote.fill")
                .font(.system(size: 60))
                .foregroundColor(.green)
                .padding(.top, 40)

            VStack(spacing: 12) {
                PaymentDetailRow(label: "Payment ID", value: payment.id)
                PaymentDetailRow(label: "Method", value: payment.method.capitalized) // ✅ changed from type → method
                PaymentDetailRow(label: "Reference", value: payment.reference)
                PaymentDetailRow(label: "Amount", value: "KES \(Int(payment.amount))")
                PaymentDetailRow(label: "Date", value: payment.dateFormatted)
                PaymentDetailRow(label: "Status", value: payment.status.capitalized)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)

            Spacer()
        }
        .padding()
        .navigationTitle("Payment Details")
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

