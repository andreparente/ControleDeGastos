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
        executar = false
        view.backgroundColor = corAzul
        viewSuperior.backgroundColor = corAzul
        tableView.frame = (CGRectMake(0,44,view.frame.width,view.frame.height))
        tableView.estimatedRowHeight = 50
        // apenas para poder enxergar os botoes
        self.botaoFiltrar.backgroundColor = corVerde
        self.botaoOrdenar.backgroundColor = corVerde
        self.botaoFiltrar.titleLabel?.textColor = UIColor.whiteColor()
        self.botaoOrdenar.titleLabel?.textColor = UIColor.whiteColor()
        if (eamarela)
        {
            view.backgroundColor = corAmarela
            viewSuperior.backgroundColor = corAmarela
        }
        if (evermelha)
        {
            view.backgroundColor = corVermelha
            viewSuperior.backgroundColor = corVermelha
        }
        
        if (self.gastos.count <= 0) {
            // por padrao, filtra os gastos pelo ultimo mes
            self.gastos = userLogged.getGastosUltimoMês()
        }
        else {
            self.gastos = userLogged.getGastos()
        }
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func viewWillAppear(animated: Bool) {
        executar = false
        self.tableView.reloadData()
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
        
        cell.backgroundColor = corAzul
        
        if (cellsNumber > 0) {
            cell.hideInfo(false)
            cell.labelNomeGasto.text = "\(self.gastos[indexPath.row].name!)"
            cell.labelCat.text = "\(self.gastos[indexPath.row].category)"
            cell.labelValor.text = "R$ " + String(self.gastos[indexPath.row].value)
            cell.labeldata.text = "\(self.gastos[indexPath.row].date)"
            if (eamarela)
            {
              cell.backgroundColor = corAmarela
            }
            if (evermelha)
            {
                cell.backgroundColor = corVermelha
            }
        } else {
            cell.hideInfo(true)
            cell.labelSemGastos.text = "Nenhum gasto para exibir!"
        }
        return cell
    }
    
    //funçao que é chamada ao clicar em determinada célula
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell #\(indexPath.row)!")
    }
    
    @IBAction func apertouBotaoOrdenar(sender: AnyObject) {
        performSegueWithIdentifier("HistoricoTabelaToOrdenar", sender: nil)
    }
    
    @IBAction func apertouBotaoFiltrar(sender: AnyObject) {
        performSegueWithIdentifier("HistoricoTabelaToFiltrar", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "HistoricoTabelaToFiltrar" {
            let destino = segue.destinationViewController as! FiltrarViewController
            destino.delegate = self
            //destino.gastos = self.gastos
        } else if segue.identifier == "HistoricoTabelaToOrdenar" {
            let destino = segue.destinationViewController as! OrdenarViewController
            destino.delegate = self
            destino.gastos = self.gastos
        }
    }
}
