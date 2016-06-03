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
        
        var dict1 = plist.getData()
        print(plist.plistName)
        if plist.getData() != nil && dict1!["isLogged"] as! String != "loggedOut" {
            dispatch_async(dispatch_get_main_queue(),{
                var dict = plist.getData()
                userLogged = User(name: dict!["name"] as! String, email: dict!["email"] as! String, password: dict!["password"] as! String)
                self.performSegueWithIdentifier("LaunchToMain", sender: self)


            })
        }
        else {
            
            dispatch_async(dispatch_get_main_queue(),{
        
                self.performSegueWithIdentifier("LaunchToLogin", sender: self)
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
}
