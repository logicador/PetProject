//
//  MainViewController.swift
//  PetProject
//
//  Created by 서원영 on 2021/02/09.
//

import UIKit


class MainViewController: UITabBarController {
    
    // MARK: Property
    let homeVC = HomeViewController()
    let productListVC = ProductListViewController()
    let myPetVC = MyPetViewController()
    let searchVC = SearchViewController()
    let settingVC = SettingViewController()
    
    
    // MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        title = "앱이름없음"
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        homeVC.mainVC = self
        productListVC.mainVC = self
        myPetVC.mainVC = self
        
        homeVC.tabBarItem.title = "홈"
        homeVC.tabBarItem.image = UIImage(imageLiteralResourceName: "TabHome")
        homeVC.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "TabHomeActive")
        
        productListVC.tabBarItem.title = "제품후기"
        productListVC.tabBarItem.image = UIImage(imageLiteralResourceName: "TabProduct")
        productListVC.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "TabProductActive")
        
        myPetVC.tabBarItem.title = "마이펫"
        myPetVC.tabBarItem.image = UIImage(imageLiteralResourceName: "TabMyPet")
        myPetVC.tabBarItem.selectedImage = UIImage(imageLiteralResourceName: "TabMyPetActive")
        
        setViewControllers([homeVC, productListVC, myPetVC], animated: false)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingTapped))
//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(settingTapped)),
//            UIBarButtonItem(image: UIImage(systemName: "bell"), style: .plain, target: self, action: #selector(bellTapped))
//        ]
        
        delegate = self
    }
    
    
    // MARK: Function
    func openProductListVC(category: String) {
        productListVC.selectedTab = "SIMILAR"
        productListVC.selectedFilter = ProductFilter(filter: "RCNT", name: "최신순")
        productListVC.selectedCategory = category
        selectedIndex = 1
    }
    
    // MARK: Function - @OBJC
//    @objc func bellTapped() {
//
//    }
    
    @objc func settingTapped() {
        navigationController?.pushViewController(settingVC, animated: true)
    }
    
    @objc func searchTapped() {
        present(UINavigationController(rootViewController: searchVC), animated: true, completion: nil)
//        navigationController?.pushViewController(searchVC, animated: true)
    }
}


// MARK: TabBar
extension MainViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is HomeViewController {
            title = "앱이름없음"
        }
        if viewController is ProductListViewController {
            title = "제품후기"
        }
        if viewController is MyPetViewController {
            title = "마이펫"
        }
        return true
    }
}
