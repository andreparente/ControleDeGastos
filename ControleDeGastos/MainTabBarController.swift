//
//  MainTabBarController.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 05/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.hidden = true
        self.tabBar.backgroundColor = corVerde
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MainTabBarController.actOnNotificationSuccessLoad), name: "notificationSuccessLoadUser", object: nil)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
     func actOnNotificationSuccessLoad()
     {
        self.tabBar.hidden = false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
