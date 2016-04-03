//
//  HistoricoTabelaViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class HistoricoTabelaViewController: UITableViewController, UIGestureRecognizerDelegate  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)

        tableView.frame = (CGRectMake(0,44,view.frame.width,view.frame.height))
        tableView.estimatedRowHeight = 50
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //funçao que diz a quantidade de células
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if(base.usuarioLogado!.gastos.count == 0) {
            return 1
        }
            
        else {
            
            return base.usuarioLogado!.gastos.count
        }

    }
    
    //funçao que seta as células
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            self.tableView.dequeueReusableCellWithIdentifier(
                "TableViewCell", forIndexPath: indexPath)
                as! TableViewCell
        let cellsNumber = base.usuarioLogado?.gastos.count
        cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        
        if (cellsNumber > 0) {
            cell.labelNomeGasto.text = "Gasto:\((base.usuarioLogado?.gastos[indexPath.row].nome)!)"
            cell.labelCat.text = "Tipo:\((base.usuarioLogado?.gastos[indexPath.row].categoria)!)"
            cell.labelValor.text = "R$: " + String(base.usuarioLogado!.gastos[indexPath.row].valor)
        } else {
            cell.labelNomeGasto.text = "Você Não Possui Gastos!"
            cell.labelNomeGasto.center = cell.center
        }
        return cell
    }
    
    //funçao que é chamada ao clicar em determinada célula
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //print("ViewWillAppear eh chamada sempre")
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
