//
//  LaunchViewController.swift
//  ControleDeGastos
//
//  Created by Felipe Viberti on 3/29/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit
import SystemConfiguration
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
                var dict1 = plist.getData()
                print(plist.plistName)
                if dict1 != nil && dict1!["isLogged"] as! String != "loggedOut" {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        var dict = plist.getData()
                        userLogged = User(name: dict!["name"] as! String, email: dict!["email"] as! String, password: dict!["password"] as! String)
                        executarLoad = true
                        self.performSegueWithIdentifier("LaunchToMain", sender: self)
                        
                    })
                }
                else {
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        print("passou pelo segue launchToLogin")
                        self.performSegueWithIdentifier("LaunchToLogin", sender: self)
                    })
                }
                
            }))
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else
        {
            var dict1 = plist.getData()
            print(plist.plistName)
            if dict1 != nil && dict1!["isLogged"] as! String != "loggedOut" {
                
                dispatch_async(dispatch_get_main_queue(),{
                    var dict = plist.getData()
                    userLogged = User(name: dict!["name"] as! String, email: dict!["email"] as! String, password: dict!["password"] as! String)
                    executarLoad = true
                    self.performSegueWithIdentifier("LaunchToMain", sender: self)
                    
                })
            }
            else {
                
                dispatch_async(dispatch_get_main_queue(),{
                    print("passou pelo segue launchToLogin")
                    self.performSegueWithIdentifier("LaunchToLogin", sender: self)
                })
            }
            
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
}
public class Reachability {
    class func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(sizeofValue(zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(&zeroAddress) {
            SCNetworkReachabilityCreateWithAddress(nil, UnsafePointer($0))
        }
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
    }
}
