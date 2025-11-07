# Rental Manager

A comprehensive iOS application for managing rental properties, built with SwiftUI and Firebase.

## 📱 Features

### For Tenants
- **Dashboard** - Overview of rental information and quick actions
- **Bill Management** - View and pay bills with multiple payment methods
- **Maintenance Requests** - Submit and track maintenance requests
- **Payment History** - Access complete payment records
- **Notifications** - Stay updated with important alerts
- **Profile Management** - Update personal information and preferences

### Core Functionality
- User authentication (Login/Register/Password Recovery)
- Secure payment processing
- Real-time notifications
- Local data storage
- Firebase integration

## 🛠 Tech Stack

- **Framework**: SwiftUI
- **Backend**: Firebase
- **Language**: Swift
- **Architecture**: MVVM (Model-View-ViewModel)
- **Storage**: Local JSON + Firebase

## 📂 Project Structure

```
rentalmanager/
├── Model/                      # Data models
│   ├── User.swift
│   ├── Bill.swift
│   ├── Payment.swift
│   ├── MaintenanceRequest.swift
│   └── NotificationItem.swift
├── Views/                      # UI Components
│   ├── Auth/                   # Authentication screens
│   ├── Dashboard/              # Dashboard view
│   ├── Bills/                  # Bill management
│   ├── Payments/               # Payment history
│   ├── Maintenance/            # Maintenance requests
│   ├── Notifications/          # Notifications
│   ├── Profile/                # User profile
│   ├── Shared/                 # Reusable components
│   └── Utility/                # Utility views
├── ViewModels/                 # Business logic
│   ├── AuthViewModel.swift
│   ├── BillViewModel.swift
│   ├── PaymentViewModel.swift
│   ├── MaintenanceViewModel.swift
│   ├── DashboardViewModel.swift
│   └── ProfileViewModel.swift
├── Services/                   # Service layer
│   ├── AuthService.swift
│   └── LocalStorageService.swift
├── Extensions/                 # Swift extensions
└── Data/                       # Local JSON storage
```

## 🚀 Getting Started

### Prerequisites

- Xcode 14.0 or later
- iOS 15.0 or later
- Swift 5.7 or later
- CocoaPods or Swift Package Manager
- Firebase account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/mabuya02/rentalmanager2.git
   cd rentalmanager2
   ```

2. **Install dependencies**
   
   If using Swift Package Manager, Xcode will automatically resolve dependencies.

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Add an iOS app to your Firebase project
   - Download `GoogleService-Info.plist`
   - Add the file to the `rentalmanager/` directory (it's gitignored for security)

4. **Open the project**
   ```bash
   open rentalmanager.xcodeproj
   ```

5. **Build and Run**
   - Select your target device or simulator
   - Press `Cmd + R` to build and run

## 🔐 Configuration

### Firebase Configuration

1. Enable Authentication in Firebase Console
2. Set up Firestore Database
3. Configure security rules
4. Add your `GoogleService-Info.plist` to the project

### Local Data

The app uses local JSON files for development/testing in the `Data/` folder:
- `users.json`
- `bills.json`
- `payments.json`
- `maintenanceRequests.json`
- `notifications.json`

**Note**: These files are gitignored to prevent committing sensitive or test data.

## 👥 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is private and proprietary.

## 📧 Contact

Manasseh Abuya - [@mabuya02](https://github.com/mabuya02)

Project Link: [https://github.com/mabuya02/rentalmanager2](https://github.com/mabuya02/rentalmanager2)

## 🙏 Acknowledgments

- SwiftUI for the modern UI framework
- Firebase for backend services
- [Add any other libraries or resources you've used]
