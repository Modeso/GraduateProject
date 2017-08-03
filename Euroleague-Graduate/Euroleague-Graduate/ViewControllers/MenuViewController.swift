//
//  MenuViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/2/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = Colors.TurkishLeagueBarColor
        navigationController?.navigationBar.isTranslucent = false
        let navImage = UIImage(named: "navbar-turkishairlines")
        let navImageView = UIImageView(image: navImage)
        navImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = navImageView
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    

}

extension UIColor {
    
    func getTurkishLeagueBarColor() -> UIColor{
        return UIColor(red: 255.0/255, green: 88.0/255, blue: 4.0/255, alpha: 1)
    }
    
    func getTurkishLeagueBackGroundColor() -> UIColor {
        return UIColor(red: 77.0/255.0, green: 77.0/255.0, blue: 77.0/255.0, alpha: 1)
    }
}
