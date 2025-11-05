//
//  UIApplication+TopController.swift
//  rentalmanager
//
//  Created by Manasseh Mabuya Maina on 05/11/2025.
//

import UIKit

extension UIApplication {
    /// Returns the topmost visible UIViewController for presenting alerts safely (iOS 15+)
    static func topMostController() -> UIViewController? {
        guard let windowScene = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .first(where: { $0.activationState == .foregroundActive }),
              let root = windowScene.windows.first(where: { $0.isKeyWindow })?.rootViewController else {
            return nil
        }

        var topController = root
        while let presented = topController.presentedViewController {
            topController = presented
        }
        return topController
    }
}

