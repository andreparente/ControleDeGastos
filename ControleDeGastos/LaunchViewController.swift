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
        if(NSUserDefaults.standardUserDefaults().boolForKey("HasLaunchedOnce"))
        {
            // app already launched
            print("Entrou")
            dispatch_async(dispatch_get_main_queue()){
                
                self.performSegueWithIdentifier("LaunchToMain", sender: self)
                
            }

            print("Fez segue")
        }
        else
        {
            // This is the first launch ever
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "HasLaunchedOnce")
            NSUserDefaults.standardUserDefaults().synchronize()
            dispatch_async(dispatch_get_main_queue()){
                
                self.performSegueWithIdentifier("LaunchToLogin", sender: self)
                
            }
        }
        // Do any additional setup after loading the view.
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
