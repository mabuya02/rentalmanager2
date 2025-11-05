//
//  NotificationsListView.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import SwiftUI

struct NotificationsListView: View {
    @ObservedObject var authVM: AuthViewModel

    // Replace this with your real NotificationsViewModel when ready
    let sample: [NotificationItem] = [
        .init(id: "n1", userId: "u1", title: "Welcome", message: "Thanks for joining RentalManager!", isRead: false, createdAt: "2025-11-05T09:30:00Z")
    ]

    var body: some View {
        NavigationStack {
            List(sample, id: \.id) { n in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(n.title).font(.headline)
                        Spacer()
                        Circle()
                            .fill(n.isRead ? Color.clear : Color.blue)
                            .frame(width: 8, height: 8)
                    }
                    Text(n.message).font(.subheadline).foregroundColor(.gray)
                }
                .padding(.vertical, 4)
            }
            .navigationTitle("Notifications")
        }
    }
}

