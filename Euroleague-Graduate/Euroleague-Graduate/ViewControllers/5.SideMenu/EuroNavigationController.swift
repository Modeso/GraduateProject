//
//  EuroLeagueNavigationController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/4/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class EuroNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension EuroNavigationController:  UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationBar.barTintColor = UIColor.getLeagueBarColor()
        navigationBar.tintColor = UIColor.white
        navigationBar.isTranslucent = false
        let navImage = Constants.season.getNavImage()
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
//        navImageView.center = CGPoint(x: navigationBar.center.x, y: navigationBar.center.y - 20)
        viewController.navigationItem.titleView = navImageView
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, style: .plain, target: self, action: nil)
        navigationBar.setValue(true, forKey: "hidesShadow")
        viewController.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}
