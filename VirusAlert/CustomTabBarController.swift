//
//  CustomTabBarController.swift
//  VirusAlert
//
//  Created by Seow Yung Hoe on 01/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
         setViewControllers([createMapViewController(imageName: "map"), createTipsViewController(imageName: "tips"), createStatisticsViewController(imageName: "statistics")], animated: true)

    }

    
    func createMapViewController(imageName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let mapViewController = storyboard.instantiateViewController(withIdentifier: "MapViewController")
        let navController = UINavigationController(rootViewController: mapViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }
    
    func createTipsViewController(imageName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: "Tips", bundle: Bundle.main)
        let tipsViewController = storyboard.instantiateViewController(withIdentifier: "TipsViewController")
        let navController = UINavigationController(rootViewController: tipsViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController


}
    
    func createStatisticsViewController(imageName: String) -> UINavigationController{
        let storyboard = UIStoryboard(name: "Statistics", bundle: Bundle.main)
        let mapViewController = storyboard.instantiateViewController(withIdentifier: "StatisticsViewController")
        let navController = UINavigationController(rootViewController: mapViewController)
        navController.tabBarItem.image = UIImage(named: imageName)
        return navController
    }

}
