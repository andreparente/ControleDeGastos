//
//  CustomPageViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 8/25/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class CustomPageViewController: UIViewController,BWWalkthroughPage {
    
    @IBOutlet var imageView:UIImageView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: BWWalkThroughPage protocol
    
    func walkthroughDidScroll(position: CGFloat, offset: CGFloat) {
        var tr = CATransform3DIdentity
        tr.m34 = -1/500.0
        
        /*  titleLabel?.layer.transform = CATransform3DRotate(tr, CGFloat(M_PI) * (1.0 - offset), 1, 1, 1)
         textLabel?.layer.transform = CATransform3DRotate(tr, CGFloat(M_PI) * (1.0 - offset), 1, 1, 1)*/
        
        var tmpOffset = offset
        if(tmpOffset > 1.0){
            tmpOffset = 1.0 + (1.0 - tmpOffset)
        }
        imageView?.layer.transform = CATransform3DTranslate(tr, 0 , (1.0 - tmpOffset) * 200, 0)
    }
    
}