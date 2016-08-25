//
//  TutorialViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 8/25/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, BWWalkthroughViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        // Get view controllers and build the walkthrough
        let stb = UIStoryboard(name: "Walkthrough", bundle: nil)
        let walkthrough = stb.instantiateViewControllerWithIdentifier("Master") as! BWWalkthroughViewController
        let page_zero = stb.instantiateViewControllerWithIdentifier("walk0")
        let page_one = stb.instantiateViewControllerWithIdentifier("walk1")
        let page_two = stb.instantiateViewControllerWithIdentifier("walk2")
        let page_three = stb.instantiateViewControllerWithIdentifier("walk3")
       /* let page_four = stb.instantiateViewControllerWithIdentifier("walk4")
        let page_five = stb.instantiateViewControllerWithIdentifier("walk5")
        let page_six = stb.instantiateViewControllerWithIdentifier("walk6")
        let page_seven = stb.instantiateViewControllerWithIdentifier("walk7")
        let page_eight = stb.instantiateViewControllerWithIdentifier("walk8")*/
        walkthrough.delegate = self
        
        
        // Attach the pages to the master
        walkthrough.addViewController(page_zero)
        walkthrough.addViewController(page_one)
        walkthrough.addViewController(page_two)
        walkthrough.addViewController(page_three)
        
      /*  walkthrough.addViewController(page_four)
        walkthrough.addViewController(page_five)
        walkthrough.addViewController(page_six)
        walkthrough.addViewController(page_seven)
        walkthrough.addViewController(page_eight)*/
        
        self.presentViewController(walkthrough, animated: true, completion: nil)
    }
    
    func walkthroughPageDidChange(pageNumber: Int) {
        print("Current Page \(pageNumber)")
    }
    
    func walkthroughCloseButtonPressed() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainController = storyboard.instantiateViewControllerWithIdentifier("MainTabBarController") as! UITabBarController
        defaults.setBool(true, forKey: "notFirstLaunch")
        
        let top = topMostController()
        top?.presentViewController(mainController, animated: true, completion: nil)
    }
    
    func topMostController() -> UIViewController? {
        var topController = UIApplication.sharedApplication().keyWindow?.rootViewController
        
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        return topController
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
