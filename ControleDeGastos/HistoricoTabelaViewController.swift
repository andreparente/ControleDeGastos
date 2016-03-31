//
//  HistoricoTabelaViewController.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 3/23/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class HistoricoTabelaViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate  {
    
    var tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        
        tableView.frame = CGRectMake(0,screenSize.minY+22,screenSize.width,screenSize.height)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
    }
    
    //funçao que diz a quantidade de células
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(base.usuarioLogado!.gastos.count > 0) {
            return (base.usuarioLogado?.gastos.count)!
        }
        else {
            return 1
        }
    }
    
    //funçao que seta as células
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if(base.usuarioLogado?.gastos.count > 0) {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = (base.usuarioLogado?.gastos[indexPath.row].nome)! + " " + (base.usuarioLogado?.gastos[indexPath.row].categoria)!
            
            cell.textLabel?.font = UIFont.systemFontOfSize(CGFloat(15))
            cell.detailTextLabel?.text = "R$: " + String(base.usuarioLogado!.gastos[indexPath.row].valor)
            cell.detailTextLabel?.font = UIFont.systemFontOfSize(CGFloat(10))
            cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
            return cell
            
        }
        else {
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
            
            cell.textLabel?.text = "Você Não Possui Gastos!"
            cell.textLabel?.font = UIFont.systemFontOfSize(CGFloat(20))
            cell.textLabel?.center = cell.center
            cell.backgroundColor = UIColor(red: 105/255, green: 181/255, blue: 120/255, alpha: 0.9)
            return cell
        }
    }
    
    //funçao que é chamada ao clicar em determinada célula
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
