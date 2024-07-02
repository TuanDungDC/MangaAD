//
//  SceneDelegate.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/5/24.
//

import UIKit
import FirebaseAuth
import SystemConfiguration

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window.backgroundColor = UIColor.white
        
        // Sử dụng LaunchScreenViewController làm rootViewController
        let launchScreenViewController = LaunchScreenViewController()
        window.rootViewController = launchScreenViewController
        
        window.makeKeyAndVisible()
        self.window = window
        
        // Kiểm tra kết nối mạng khi mở ứng dụng
        if !isConnectedToNetwork() {
            // Hiển thị thông báo khi không có kết nối mạng
            showAlert()
        } else {
            // Đặt một Timer để chuyển đổi sau 3 giây
            Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
                self.switchToMainInterface(for: window)
            }
        }
    }
    
    private func switchToMainInterface(for window: UIWindow) {
        let newRootVC: UIViewController
        if Auth.auth().currentUser != nil {
            newRootVC = UINavigationController(rootViewController: TabBarViewController())
        } else {
            newRootVC = UINavigationController(rootViewController: LoginViewController())
        }

        // Tạo animation khi thay đổi rootViewController
        UIView.transition(with: window, duration: 0.3, options: .transitionFlipFromRight, animations: {
            window.rootViewController = newRootVC
        })
    }
    
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "Không có kết nối mạng", message: "Vui lòng kiểm tra kết nối internet của bạn", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        // Hiển thị thông báo trên rootViewController
        window?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    
}

