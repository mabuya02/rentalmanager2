import SwiftUI

struct BillDetailModal: View {
    var bill: Bill
    @Environment(\.dismiss) var dismiss
    @ObservedObject var billVM = BillViewModel()

    @State private var showPaymentMethodSheet = false
    @State private var selectedPaymentMethod: PaymentMethod? = nil
    @State private var showPaymentSheet = false
    @State private var showSuccess = false

    enum PaymentMethod: String, CaseIterable {
        case mpesa = "M-Pesa"
        case bank = "Bank Transfer"
    }

    private let currencyFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.currencyCode = "KES"
        f.minimumFractionDigits = 2
        return f
    }()

    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Capsule()
                    .frame(width: 40, height: 5)
                    .foregroundColor(.gray.opacity(0.3))
                    .padding(.top, 12)

                Image(systemName: bill.status.lowercased() == "paid" ? "checkmark.circle.fill" : "clock.fill")
                    .font(.system(size: 60))
                    .foregroundColor(bill.status.lowercased() == "paid" ? .green : .orange)
                    .padding(.top, 10)

                Text(bill.type.capitalized)
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(alignment: .leading, spacing: 16) {
                    BillDetailRow(icon: "calendar", label: "Due Date", value: bill.dueDateFormatted)
                    BillDetailRow(icon: "banknote.fill", label: "Amount",
                                  value: currencyFormatter.string(from: NSNumber(value: bill.amount)) ?? "KES 0.00")
                    BillDetailRow(icon: "doc.text.fill", label: "Status", value: bill.status.capitalized)
                    BillDetailRow(icon: "number", label: "Bill ID", value: bill.id)
                    BillDetailRow(icon: "person.fill", label: "User ID", value: bill.userId)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(16)
                .shadow(color: .gray.opacity(0.15), radius: 6, y: 3)

                // MARK: - Pay Bill button
                if bill.status.lowercased() == "unpaid" {
                    Button {
                        showPaymentMethodSheet = true
                    } label: {
                        Text("Pay Bill")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .shadow(color: .blue.opacity(0.3), radius: 6, y: 3)
                    }
                    .padding(.top, 10)
                }

                Spacer()
            }
            .padding()
            .background(Color(.systemGroupedBackground))
            .presentationDetents([.fraction(0.65), .large])
            .presentationDragIndicator(.visible)
            .sheet(isPresented: $showPaymentMethodSheet) {
                PaymentMethodSelectionView(selectedMethod: $selectedPaymentMethod, showPaymentSheet: $showPaymentSheet)
            }
            .sheet(isPresented: $showPaymentSheet) {
                if let method = selectedPaymentMethod {
                    PaymentProcessView(
                        method: method,
                        amount: bill.amount,
                        bill: bill,
                        billVM: billVM,
                        showSuccess: $showSuccess
                    )
                }
            }

            // ✅ Smooth success banner overlay (no alerts)
            if showSuccess {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.white)
                        Text("Payment Successful")
                            .foregroundColor(.white)
                            .fontWeight(.medium)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation {
                                showSuccess = false
                                dismiss()
                            }
                        }
                    }
                }
                .padding(.bottom, 30)
                .animation(.easeInOut, value: showSuccess)
            }
        }
    }
}

// MARK: - Detail Row
private struct BillDetailRow: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundColor(.blue)
                .frame(width: 140, alignment: .leading)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .font(.subheadline)
    }
}

