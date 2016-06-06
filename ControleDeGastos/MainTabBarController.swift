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
        let delay = 3.0 * Double(NSEC_PER_SEC)
        let time1 = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time1, dispatch_get_main_queue(), {
        self.tabBar.backgroundColor = corVerde
           self.tabBar.hidden = false
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
