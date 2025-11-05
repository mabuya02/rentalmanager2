//
//  DashboardComponents.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI

// MARK: - Horizontal Dashboard Card
struct DashboardCardHorizontal: View {
    var title: String
    var value: String
    var subtitle: String
    var icon: String
    var gradient: LinearGradient
    var color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.15))
                        .frame(width: 50, height: 50)
                    Image(systemName: icon)
                        .foregroundColor(color)
                        .font(.title2)
                }
                Spacer()
            }

            Text(title)
                .font(.headline)
                .foregroundColor(.black)

            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)

            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: 230, height: 150)
        .background(gradient)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(color.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Quick Action Button
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

// MARK: - Payment Detail Modal
struct PaymentDetailModal: View {
    let payment: Payment

    var body: some View {
        VStack(spacing: 20) {
            Capsule()
                .fill(Color.gray.opacity(0.4))
                .frame(width: 40, height: 5)
                .padding(.top, 8)

            Text("Payment Details")
                .font(.title3)
                .fontWeight(.semibold)
                .padding(.top, 10)

            VStack(alignment: .leading, spacing: 16) {
                PaymentDetailRow(label: "Payment ID", value: payment.id)
                PaymentDetailRow(label: "Method", value: payment.method.capitalized)
                PaymentDetailRow(label: "Amount", value: "KES \(Int(payment.amount))")
                PaymentDetailRow(label: "Date", value: payment.dateFormatted)
                PaymentDetailRow(label: "Status", value: payment.status.capitalized)
                PaymentDetailRow(label: "Reference", value: payment.reference)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)

            Spacer()
        }
        .padding()
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
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

