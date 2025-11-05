import SwiftUI

struct PaymentMethodSelectionView: View {
    @Binding var selectedMethod: BillDetailModal.PaymentMethod?
    @Binding var showPaymentSheet: Bool
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section("Select Payment Method") {
                    Button {
                        selectedMethod = .mpesa
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showPaymentSheet = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "phone.fill")
                                .foregroundColor(.green)
                            Text("M-Pesa")
                        }
                    }

                    Button {
                        selectedMethod = .bank
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            showPaymentSheet = true
                        }
                    } label: {
                        HStack {
                            Image(systemName: "building.columns.fill")
                                .foregroundColor(.blue)
                            Text("Bank Transfer")
                        }
                    }
                }
            }
            .navigationTitle("Payment Options")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

