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
        if DAOCloudKit().cloudAvailable() == false{
            let alert=UIAlertController(title:"iCloud não disponível", message: "Você nāo está logado na sua conta do iCloud, por favor, conecte-se antes de usar este aplicativo!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{(action) -> Void in
                exit(0)
            }))
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else if Reachability.isConnectedToNetwork() == false
        {
            let alert=UIAlertController(title:"Internet não disponível", message: "Você nāo está conectado à internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{(action) -> Void in
                exit(0)
            }))
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else
        {
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
            vc.selectedIndex = 0
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        print("viewWillAppear da launch")
    }
}