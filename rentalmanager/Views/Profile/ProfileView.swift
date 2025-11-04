import SwiftUI

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        VStack(spacing: 24) {
            // MARK: Profile Header
            VStack(spacing: 10) {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.purple)
                Text(viewModel.user?.name ?? "—")
                    .font(.title2).fontWeight(.semibold)
                Text(viewModel.user?.email ?? "")
                    .foregroundColor(.gray)
            }
            .padding(.top, 40)

            Divider()

            // MARK: Menu List
            VStack(spacing: 20) {
                ProfileRow(icon: "gearshape.fill", title: "Settings")
                ProfileRow(icon: "creditcard.fill", title: "Payments")
                ProfileRow(icon: "bell.fill", title: "Notifications")
                ProfileRow(icon: "clock.fill", title: "Recent Activity")
                ProfileRow(icon: "info.circle.fill", title: "About")
            }
            .padding(.horizontal)

            Spacer()

            // MARK: Logout
            Button(action: authVM.logout) {
                Text("Sign Out")
                    .fontWeight(.semibold)
                    .foregroundColor(.red)
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            viewModel.loadProfile(for: authVM.userEmail)
        }
    }
}

struct ProfileRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack {
            Label(title, systemImage: icon)
                .foregroundColor(.purple)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .font(.body)
    }
}

