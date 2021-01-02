//
//  QoutesCell.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 1/1/21.
//  Copyright © 2021 Kanan`s Macbook Pro. All rights reserved.
//

import UIKit

class QuotesCell: UITableViewCell {
    @IBOutlet weak var symbol: UIImageView!
    @IBOutlet weak var quote: UILabel!
    @IBOutlet weak var bid: UILabel!
    @IBOutlet weak var ask: UILabel!
    @IBOutlet weak var spread: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func removePressed(_ sender: UIButton) {
        print("remove from ui")
    }
    
}
