import SwiftUI

struct ProfileView: View {
    @ObservedObject var authVM: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showSavedBanner = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.blue.opacity(0.08), Color.white],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    // MARK: - Header
                    VStack(spacing: 8) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 25)
                                .fill(LinearGradient(colors: [.blue.opacity(0.15), .purple.opacity(0.1)],
                                                     startPoint: .topLeading, endPoint: .bottomTrailing))
                                .shadow(color: .gray.opacity(0.2), radius: 10, y: 5)
                                .frame(height: 220)

                            VStack(spacing: 10) {
                                AsyncImage(url: URL(string: viewModel.profileImageURL)) { phase in
                                    switch phase {
                                    case .empty:
                                        ProgressView().frame(width: 100, height: 100)
                                    case .success(let image):
                                        image.resizable()
                                            .scaledToFill()
                                            .frame(width: 100, height: 100)
                                            .clipShape(Circle())
                                    case .failure:
                                        Image(systemName: "person.circle.fill")
                                            .resizable()
                                            .frame(width: 100, height: 100)
                                            .foregroundColor(.blue)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }

                                Text(viewModel.userName.isEmpty ? "—" : viewModel.userName)
                                    .font(.title2)
                                    .fontWeight(.bold)

                                Text(viewModel.user?.email ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)

                                Text("Unit \(viewModel.unitNumber)")
                                    .font(.footnote)
                                    .foregroundColor(.gray.opacity(0.8))
                            }
                        }
                    }
                    .padding(.top, 10)

                    // MARK: - Personal Info
                    VStack(alignment: .leading, spacing: 18) {
                        Text("Personal Information")
                            .font(.headline)

                        ProfileField(label: "Full Name") {
                            TextField("Your full name", text: $viewModel.userName)
                                .textFieldStyle(.roundedBorder)
                        }

                        ProfileField(label: "Email") {
                            Text(viewModel.user?.email ?? "—")
                                .foregroundColor(.gray)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ProfileField(label: "Phone") {
                            TextField("+2547...", text: $viewModel.phone)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                        }

                        ProfileField(label: "Unit Number") {
                            Text(viewModel.unitNumber)
                                .foregroundColor(.gray)
                                .italic()
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        ProfileField(label: "Profile Image URL") {
                            TextField("https://...", text: $viewModel.profileImageURL)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.URL)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.15), radius: 8, y: 3)
                    .padding(.horizontal)

                    // MARK: - Rental Summary
                    VStack(spacing: 12) {
                        Text("Rental Summary")
                            .font(.headline)

                        SummaryRow(icon: "building.2.crop.circle", label: "Property", value: viewModel.propertyName)
                        SummaryRow(icon: "calendar", label: "Lease End", value: viewModel.leaseEndDate)
                        SummaryRow(icon: "creditcard.fill", label: "Rent Due", value: "KES \(Int(viewModel.rentDue))")
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.15), radius: 8, y: 3)
                    .padding(.horizontal)

                    // MARK: - Support
                    VStack(spacing: 16) {
                        Button {
                            viewModel.contactSupport()
                        } label: {
                            InfoRow(icon: "envelope.fill", label: "Contact Support", tint: .blue)
                        }

                        Button {
                            viewModel.showAbout()
                        } label: {
                            InfoRow(icon: "info.circle.fill", label: "About App", tint: .purple)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(color: .gray.opacity(0.15), radius: 8, y: 3)
                    .padding(.horizontal)

                    // MARK: - Save Changes
                    Button {
                        viewModel.saveProfileChanges()
                        withAnimation { showSavedBanner = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showSavedBanner = false }
                        }
                    } label: {
                        Text("Save Changes")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(14)
                            .shadow(color: .blue.opacity(0.3), radius: 6, y: 3)
                            .padding(.horizontal)
                    }

                    // MARK: - Logout
                    VStack(spacing: 8) {
                        Divider().padding(.horizontal)
                        Button(action: authVM.logout) {
                            Label("Sign Out", systemImage: "arrowshape.turn.up.left.fill")
                                .fontWeight(.semibold)
                                .foregroundColor(.red)
                        }
                        .padding(.bottom, 40)
                    }
                }
            }

            // MARK: - Saved Banner
            if showSavedBanner {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                        Text("Profile saved")
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(12)
                    .shadow(radius: 3)
                    .padding(.horizontal)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .padding(.bottom, 24)
            }
        }
        .onAppear {
            viewModel.loadProfile(for: authVM.userEmail)
        }
    }
}

// MARK: - ProfileField Component
private struct ProfileField<Content: View>: View {
    var label: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundColor(.gray)
            content
        }
    }
}

// MARK: - Summary Row
private struct SummaryRow: View {
    var icon: String
    var label: String
    var value: String

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
        .font(.subheadline)
    }
}

// MARK: - Info Row (Support/About)
private struct InfoRow: View {
    var icon: String
    var label: String
    var tint: Color

    var body: some View {
        HStack {
            Label(label, systemImage: icon)
                .foregroundColor(tint)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 6)
        .font(.body)
    }
}

