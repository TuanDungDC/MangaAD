//
//  TabBarViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 29/7/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Đặt màu nền cho toàn bộ view của TabBarViewController
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        // Thiết lập các view controller
        setUpViews()
    }
    
    private func setUpViews() {
        
        let viewVC = ViewController()
        let favVC = FavoriteViewController()
        let cateVC = CategoryViewController()
        let profileVC = ProfileViewController()
        
        let naVC1 = UINavigationController(rootViewController: viewVC)
        let naVC2 = UINavigationController(rootViewController: favVC)
        let naVC3 = UINavigationController(rootViewController: cateVC)
        let naVC4 = UINavigationController(rootViewController: profileVC)
        
        naVC1.tabBarItem = UITabBarItem(title: "Truyện tranh", image: UIImage(systemName: "house.fill"), tag: 0)
        naVC2.tabBarItem = UITabBarItem(title: "Yêu thích", image: UIImage(systemName: "heart.fill"), tag: 1)
        naVC3.tabBarItem = UITabBarItem(title: "Thể loại", image: UIImage(systemName: "rectangle.grid.2x2.fill"), tag: 2)
        naVC4.tabBarItem = UITabBarItem(title: "Tôi", image: UIImage(systemName: "person.fill"), tag: 3)
        
//         Cấu hình màu nền cho navigation bar
        configureNavigationBar(naVC1.navigationBar)
        configureNavigationBar(naVC2.navigationBar)
        configureNavigationBar(naVC3.navigationBar)
        configureNavigationBar(naVC4.navigationBar)
        
        if #available(iOS 10.0, *) {
            // Đặt màu nền cho tab bar
            tabBar.shadowImage = UIImage()
            tabBar.backgroundImage = UIImage()
            tabBar.backgroundColor = UIColor(red: 0x05 / 255.0, green: 0x11 / 255.0, blue: 0x38 / 255.0, alpha: 1)
            tabBar.unselectedItemTintColor = UIColor(white: 1, alpha: 1)
                
            // setup shadow for tabbar
            tabBar.layer.shadowOffset = CGSize(width: 0, height: 1.5)
            tabBar.layer.shadowRadius = 5
            tabBar.layer.shadowColor = UIColor.black.cgColor
            tabBar.layer.shadowOpacity = 0.6
            tabBar.layer.masksToBounds = false
            
            // Cấu hình màu cho các item trên tab bar
            self.tabBar.tintColor = .cyan // Màu cho icon khi được chọn

        } else {
            // Fallback trên các phiên bản iOS cũ hơn
            UITabBar.appearance().tintColor = .cyan
        }
        
        setViewControllers([naVC1, naVC2, naVC3, naVC4], animated: true)
    }
    
    private func configureNavigationBar(_ navigationBar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
    }
    
}
