//
//  OrdenarViewController.swift
//  ControleDeGastos
//
//  Created by Caio Valente on 03/04/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class OrdenarViewController: UIViewController {

    var delegate = HistoricoTabelaViewController()
    
    @IBOutlet weak var pickerTipoOrdenacao: UIPickerView!
    @IBOutlet weak var switchDecrescente: UISwitch!
    
    var decrescente = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // linkando funcao ao switch
        switchDecrescente.addTarget(self, action: "switchClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        // altera switch para o valor atual
        switchDecrescente.setOn(self.decrescente, animated: true)
    }
    
    func switchClicked(sender:UIButton)
    {
        dispatch_async(dispatch_get_main_queue(), {
            self.decrescente = !self.decrescente
            print (self.decrescente)
        });
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
