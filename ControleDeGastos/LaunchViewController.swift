//
//  LaunchViewController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 3/29/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if (plist.getData().count == 0) {
            dispatch_async(dispatch_get_main_queue(),{
                
            self.performSegueWithIdentifier("LaunchToLogin", sender: self)
            })
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(),{
            var dict = plist.getData()
            userLogged = User(name: dict["name"] as! String, email: dict["email"] as! String, password: dict["password"] as! String)
            self.performSegueWithIdentifier("LaunchToMain", sender: self)
            })
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "LaunchToMain" {
            
            let vc = segue.destinationViewController as! UITabBarController
            vc.selectedIndex = 1
        }
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
