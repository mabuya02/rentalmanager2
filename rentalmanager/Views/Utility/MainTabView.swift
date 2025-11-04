//
//  MainTabView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI
import FirebaseAuth

struct MainTabView: View {
    @ObservedObject var authVM: AuthViewModel

    var body: some View {
        TabView {
            DashboardView(viewModel: authVM)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            BillsListView(authVM: authVM)
                .tabItem {
                    Label("Bills", systemImage: "doc.text.fill")
                }

            PaymentsListView(authVM: authVM)
                .tabItem {
                    Label("Payments", systemImage: "creditcard.fill")
                }

            MaintenanceListView(authVM: authVM)
                .tabItem {
                    Label("Maintenance", systemImage: "wrench.and.screwdriver.fill")
                }

            ProfileView(authVM: authVM)
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .tint(.purple) // Footer accent color
    }
}

