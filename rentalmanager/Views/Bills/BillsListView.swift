import SwiftUI
import FirebaseAuth

struct BillsListView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var billVM = BillViewModel()

    var body: some View {
        VStack {
            if billVM.bills.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "doc.text.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                    Text("No bills available.")
                        .foregroundColor(.gray)
                }
                .padding(.top, 100)
            } else {
                List(billVM.bills, id: \.id) { bill in
                    HStack {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(bill.type.capitalized)
                                .font(.headline)
                            Text("Due: \(bill.dueDateFormatted)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            Text("KES \(Int(bill.amount))")
                                .fontWeight(.bold)
                                .foregroundColor(bill.status.lowercased() == "unpaid" ? .red : .green)
                            Text(bill.status.capitalized)
                                .font(.caption)
                                .foregroundColor(bill.status.lowercased() == "unpaid" ? .red : .gray)
                        }
                    }
                    .padding(.vertical, 6)
                }
                .listStyle(.insetGrouped)
            }

            Spacer()
            Text("Total Unpaid: KES \(Int(billVM.totalUnpaid))")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.bottom, 20)
        }
        .padding(.top)
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
    }
}

