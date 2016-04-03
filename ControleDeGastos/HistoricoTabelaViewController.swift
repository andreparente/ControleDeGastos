//
//  HistoricoTabelaViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class HistoricoTabelaViewController: UITableViewController, UIGestureRecognizerDelegate  {
    
    @IBOutlet weak var viewSuperior: UIView!
    
    @IBOutlet weak var botaoOrdenar: UIButton!
    @IBOutlet weak var botaoFiltrar: UIButton!
    
    var gastos = [Gasto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)

        tableView.frame = (CGRectMake(0,44,view.frame.width,view.frame.height))
        tableView.estimatedRowHeight = 50
        
        // apenas para poder enxergar os botoes
        self.botaoFiltrar.backgroundColor = UIColor.orangeColor()
        self.botaoOrdenar.backgroundColor = UIColor.yellowColor()
        
        if (self.gastos.count <= 0) {
            // por padrao, filtra os gastos pelo ultimo mes
            self.gastos = base.usuarioLogado!.getGastosUltimoMês()
        }
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //funçao que diz a quantidade de células
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsNumber = self.gastos.count
        return (cellsNumber > 0) ? cellsNumber : 1
    }
    
    //funçao que seta as células
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            self.tableView.dequeueReusableCellWithIdentifier(
                "TableViewCell", forIndexPath: indexPath)
                as! TableViewCell
        let cellsNumber = self.gastos.count
        cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        
        if (cellsNumber > 0) {
            cell.labelNomeGasto.text = "Gasto:\(self.gastos[indexPath.row].nome)"
            cell.labelCat.text = "Tipo:\(self.gastos[indexPath.row].categoria)"
            cell.labelValor.text = "R$: " + String(self.gastos[indexPath.row].valor)
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
    
    @IBAction func apertouBotaoOrdenar(sender: AnyObject) {
        performSegueWithIdentifier("HistoricoTabelaToOrdenar", sender: nil)
    }
    
    @IBAction func apertouBotaoFiltrar(sender: AnyObject) {
        performSegueWithIdentifier("HistoricoTabelaToFiltrar", sender: nil)
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
