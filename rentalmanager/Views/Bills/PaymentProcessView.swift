//
//  PaymentProcessView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI

struct PaymentProcessView: View {
    var method: BillDetailModal.PaymentMethod
    var amount: Double
    let bill: Bill
    @ObservedObject var billVM: BillViewModel
    @Binding var showSuccess: Bool

    @Environment(\.dismiss) var dismiss
    @State private var phoneNumber: String = ""
    @State private var accountNumber: String = ""
    @State private var isProcessing = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.05), .white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 22) {
                Text(method == .mpesa ? "M-Pesa Payment" : "Bank Payment")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .padding(.top)

                Text("Amount: KES \(Int(amount))")
                    .font(.headline)
                    .foregroundColor(.blue)

                if method == .mpesa {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Phone Number")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter M-Pesa number", text: $phoneNumber)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Bank Account")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        TextField("Enter Account Number", text: $accountNumber)
                            .keyboardType(.numberPad)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal)
                }

                Button(action: processPayment) {
                    if isProcessing {
                        ProgressView("Processing…")
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding()
                    } else {
                        Text("Confirm Payment")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                    }
                }
                .background(isProcessing ? Color.gray : Color.blue)
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal)
                .disabled(isProcessing)

                Spacer()
            }

            // Optional: overlay for animation could go here if you wanted to show success
        }
    }

    private func processPayment() {
        isProcessing = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isProcessing = false
            // ✅ Mark as paid using the correct method string
            billVM.markBillAsPaid(bill, method: method.rawValue)
            dismiss()

            // Show success banner in parent
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation {
                    showSuccess = true
                }
            }
        }
    }
}

