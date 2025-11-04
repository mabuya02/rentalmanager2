//
//  ContentView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 03/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var showSplash = true
    @StateObject private var viewModel = AuthViewModel()

    var body: some View {
        Group {
            if showSplash {
                SplashView(isActive: $showSplash)
            } else {
                if viewModel.isAuthenticated {
                    DashboardView(viewModel: viewModel)
                } else {
                    LoginView()
                }
            }
        }
    }
}




