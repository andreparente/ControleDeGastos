//
//  File.swift
//  ControleDeGastos
//
//  Created by Andre Machado Parente on 4/2/16.
//  Copyright © 2016 Andre Machado Parente. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelNomeGasto: UILabel!
    
    @IBOutlet weak var labelValor: UILabel!
    
    @IBOutlet weak var labelCat: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
