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
    
    var body: some Scene {
                
        WindowGroup {
            HomeView()
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
                .environmentObject(authentificationViewModel)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    
    var window: UIWindow?

      func application(_ application: UIApplication, didFinishLaunchingWithOptionslaunchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
      }
    
    static func change(to view: AnyView) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
          let sceneDelegate = windowScene.delegate as? AppDelegate else {
          return
        }
        let contentView = view
        sceneDelegate.window?.rootViewController = UIHostingController(rootView: contentView)
    }
}

extension UIApplication {
    func addTapGestureRecognizer() {
        let scenes = UIApplication.shared.connectedScenes
        let windowScene = scenes.first as? UIWindowScene
        guard let window = windowScene?.windows.first else { return }
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
