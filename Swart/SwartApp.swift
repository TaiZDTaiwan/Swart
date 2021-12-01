//
//  SwartApp.swift
//  Swart
//
//  Created by Raphaël Huang-Dubois on 13/08/2021.
//

import SwiftUI
import UIKit
import Firebase

@main
struct SwartApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    @StateObject var authentificationViewModel = AuthentificationViewModel()
    @StateObject var storeArtistContentViewModel = StoreArtistContentViewModel()
    
    var body: some Scene {
                
        WindowGroup {
            HomeView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environmentObject(authentificationViewModel)
                .environmentObject(storeArtistContentViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?

      func application(_ application: UIApplication, didFinishLaunchingWithOptionslaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
      }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        guard let window = windows.first else { return }
        let tapGesture = UITapGestureRecognizer(target: window, action: #selector(UIView.endEditing))
        tapGesture.requiresExclusiveTouchType = false
        tapGesture.cancelsTouchesInView = false
        tapGesture.delegate = self
        window.addGestureRecognizer(tapGesture)
    }
}

extension UIApplication: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
