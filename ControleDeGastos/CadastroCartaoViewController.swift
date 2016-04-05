//
//  CadastroCartaoViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class CadastroCartaoViewController: UIViewController,UINavigationBarDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = corAzul
        
        let navigationBar = UINavigationBar(frame: CGRectMake(0, 0, self.view.frame.size.width, 53)) // Offset by 20 pixels vertically to take the status bar into account
        navigationBar.backgroundColor = corVerde
        navigationBar.delegate = self;
        
        // Create a navigation item with a title
        let navigationItem = UINavigationItem()
        navigationItem.title = "Cadastro Cartão"
        
        /*
        // Create left and right button for navigation item
        let leftButton =  UIBarButtonItem(title: "Voltar", style:   UIBarButtonItemStyle.Plain, target: self, action: #selector(CadastroCartaoViewController.btn_clicked(_:)))

        // Create two buttons for the navigation item
               navigationItem.leftBarButtonItem = leftButton
       */
        // Assign the navigation item to the navigation bar
        navigationBar.items = [navigationItem]
        
        // Make the navigation bar a subview of the current view controller
        self.view.addSubview(navigationBar)
    }
    
    func btn_clicked(sender: UIBarButtonItem) {
        // Do something
        performSegueWithIdentifier("CadastroCartaoToSettings", sender: self)
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
