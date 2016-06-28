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
        //executar = false
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        //viewSuperior.backgroundColor = corAzul
        viewSuperior.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        tableView.frame = (CGRectMake(0,44,view.frame.width,view.frame.height))
        tableView.estimatedRowHeight = 50
        // apenas para poder enxergar os botoes
        self.botaoFiltrar.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
        self.botaoOrdenar.backgroundColor = UIColor(red: 52/255, green: 52/255, blue: 52/255, alpha: 1)
        self.botaoFiltrar.titleLabel?.textColor = UIColor.whiteColor()
        self.botaoOrdenar.titleLabel?.textColor = UIColor.whiteColor()
     /*   if (eamarela)
        {
            view.backgroundColor = corAmarela
            viewSuperior.backgroundColor = corAmarela
        }
 */
        if (evermelha)
        {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "background_red.png")!)
            viewSuperior.backgroundColor = UIColor(patternImage: UIImage(named: "background_red.png")!)
        }
        if eazul{
        view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
            viewSuperior.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        }
        
        
        
        tableView.registerClass(TableViewCell.self, forCellReuseIdentifier: "cell")
    }
    override func viewWillAppear(animated: Bool) {
       // executar = false
        gastosGlobal = userLogged.gastos
        let quickSorter = QuickSorterGasto()
        quickSorter.v = gastosGlobal
        quickSorter.callQuickSort("Data", decrescente: true)
        gastosGlobal = quickSorter.v
        
        
        self.tableView.reloadData()
        if (evermelha)
        {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "background_red.png")!)
            viewSuperior.backgroundColor = UIColor(patternImage: UIImage(named: "background_red.png")!)
        }
        if (eazul)
        {
            view.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
            viewSuperior.backgroundColor = UIColor(patternImage: UIImage(named: "background_blue.png")!)
        }
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //funçao que diz a quantidade de células
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let cellsNumber = gastosGlobal.count
        return (cellsNumber > 0) ? cellsNumber : 1
    }
    
    //funçao que seta as células
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell =
            self.tableView.dequeueReusableCellWithIdentifier(
                "TableViewCell", forIndexPath: indexPath)
                as! TableViewCell
        let cellsNumber = gastosGlobal.count
        
        //cell.backgroundColor = UIColor(red: 20/255, green: 71/255, blue: 103/255, alpha: 1)
        //cell.backgroundColor = corAzul
        cell.backgroundColor = UIColor.clearColor()
        
        if (cellsNumber > 0) {
            cell.hideInfo(false)
            cell.labelNomeGasto.text = "\(gastosGlobal[indexPath.row].name!)"
            cell.labelCat.text = "\(gastosGlobal[indexPath.row].category)"
            cell.labelValor.text = "R$ " + String(gastosGlobal[indexPath.row].value)
            cell.labeldata.text = "\(gastosGlobal[indexPath.row].date)"
           /* if (eamarela)
            {
                cell.backgroundColor = UIColor.clearColor()
            }
 */
            if (evermelha)
            {
                cell.backgroundColor = UIColor.clearColor()
            }
        } else {
            cell.hideInfo(true)
            cell.labelSemGastos.text = "Nenhum gasto para exibir!"
            cell.labelSemGastos.font = UIFont(name: "Tsukushi A Round Gothic", size: 16)
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
            
        } else if segue.identifier == "HistoricoTabelaToOrdenar" {
            let destino = segue.destinationViewController as! OrdenarViewController
            destino.delegate = self
            
        }
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)

            DAOCloudKit().deleteGasto(userLogged.arrayGastos[indexPath.row], user: userLogged,index: indexPath.row)
            gastosGlobal.removeAtIndex(indexPath.row)
            userLogged.gastos = gastosGlobal
            tableView.reloadData()
            executar = true

        }
    }
}
