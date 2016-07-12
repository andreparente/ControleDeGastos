//
//  LoginCLoudViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 7/7/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

var auxID: String!
var aux8 = 0
class LoginCLoudViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        dispatch_async(dispatch_get_main_queue(),{
            
            // ------------- FUNCAO QUE PEGA O ID!! -------------
            DAOCloudKit().getId() {
                
                recordID, error in
                
                if let userID = recordID?.recordName {
                    print("received iCloudID \(userID)")
                    
                    auxID = userID
                    //defaults.setObject(userID, forKey: "cloudID")
                    //userLogged.cloudId = userID
                    
                } else {
                    print("Fetched iCloudID was nil")
                }
            }
            
            // ------------- END OF FUNCTION -------------
            
            if let cloudID = defaults.objectForKey("cloudID")
            {
                if(cloudID as? String != auxID) {
                    
                    let alert=UIAlertController(title:"Atenção", message: "Você entrou com uma nova conta do iCloud!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:nil))
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        self.presentViewController(alert,animated: true, completion: nil)
                    })
                }
                
            }
            else {
                if aux8 != 0
                {
                self.performSegueWithIdentifier("LoginCloudToMain", sender: self)
                }
            }
        })
        
        
    }
    
    @IBAction func loginActino(sender: AnyObject) {
        
        if DAOCloudKit().cloudAvailable() == false{
            let alert=UIAlertController(title:"iCloud não disponível", message: "Você nāo está logado na sua conta do iCloud, por favor, conecte-se antes de usar este aplicativo!", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:nil))
            
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else if Reachability.isConnectedToNetwork() == false
        {
            let alert=UIAlertController(title:"Internet não disponível", message: "Você nāo está conectado à internet", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:nil))
            dispatch_async(dispatch_get_main_queue(),{
                self.presentViewController(alert,animated: true, completion: nil)
            })
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),{
                
                DAOCloudKit().getId() {
                    recordID, error in
                    if let userID = recordID?.recordName {
                        print("received iCloudID \(userID)")
                        
                        auxID = userID
                        //defaults.setObject(userID, forKey: "cloudID")
                        //userLogged.cloudId = userID
                        
                    } else {
                        print("Fetched iCloudID was nil")
                    }
                }
                
                if let cloudID = defaults.objectForKey("cloudID")
                {
                    if(cloudID as! String != auxID) {
                        
                        let alert=UIAlertController(title:"Atenção", message: "Você entrou com uma nova conta do iCloud!", preferredStyle: UIAlertControllerStyle.Alert)
                        alert.addAction(UIAlertAction(title:"Ok",style: UIAlertActionStyle.Default,handler:{
                            error in
                            self.performSegueWithIdentifier("LoginCloudToMain", sender: self)
                        }))
                        
                        dispatch_async(dispatch_get_main_queue(),{
                            self.presentViewController(alert,animated: true, completion: nil)
                        })
                    }
                    
                }
                else {
                    self.performSegueWithIdentifier("LoginCloudToMain", sender: self)
                }
            })
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
