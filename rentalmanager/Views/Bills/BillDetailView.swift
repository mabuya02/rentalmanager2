//
//  BillDetailView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI

struct BillDetailView: View {
    let bill: Bill

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding(.top, 40)

            VStack(spacing: 12) {
                DetailRow(label: "Bill ID", value: bill.id)
                DetailRow(label: "Type", value: bill.type.capitalized)
                DetailRow(label: "Amount", value: "KES \(Int(bill.amount))")
                DetailRow(label: "Status", value: bill.status.capitalized)
                DetailRow(label: "Due Date", value: bill.dueDateFormatted)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(16)
            .shadow(color: .gray.opacity(0.15), radius: 5, y: 3)

            Spacer()
        }
        .padding()
        .navigationTitle("Bill Details")
    }
}

