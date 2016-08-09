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
        aux8 = 0
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginCLoudViewController().actonNotificationSucessGetID), name: "notificationSucessGetId", object: nil)
    }
    
    
    @IBAction func loginActino(sender: AnyObject) {
        
        DAOCloudKit().getId({recordID, error in
            if let userID = recordID?.recordName {
                print("received iCloudID \(userID)")
                
                //inicializa o usuário local
                userLogged = User(cloudId: userID)
                defaults.setBool(true, forKey: "Logged")
                defaults.setBool(true, forKey: "Cloud")
                self.performSegueWithIdentifier("LoginCloudToMain", sender: self)
                
            } else {
                print("Fetched iCloudID was nil")
            }})
        
    }
    
    func actonNotificationSucessGetID() {
        //TALVEZ NAO PRECISE
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    @IBAction func pularLoginAction(sender: UIButton) {
        defaults.setBool(false, forKey: "Cloud")
        defaults.setBool(true, forKey: "Logged")
        self.performSegueWithIdentifier("LoginCloudToMain", sender: self)
    }
    
}
