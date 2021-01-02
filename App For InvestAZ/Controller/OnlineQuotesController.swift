//
//  OnlineQuotesController.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/27/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import UIKit
import SocketIO
import Toast
import SwiftyJSON

class OnlineQuotesController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var allQuotesArray: [QuoteStruct] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        // Calling socket...
        self.view.makeToastActivity(.center)
        SocketIOManager.shared.establishConnection { (isConnected) in
            if isConnected {
                SocketIOManager.Events.getOnlineQuotes.getOnlineQuotesFunction()
            }
        }
        
        SocketIOManager.shared.handlerSocketData = { result in
            self.view.hideToastActivity()
            self.setAllQuotesToArray(with: result)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        SocketIOManager.shared.disconnectConnection()
    }
    
    func configureUI() {
        tableView.rowHeight = 60
    }
    
    func setAllQuotesToArray(with data: Any) {
        let json = JSON(data)
        allQuotesArray.removeAll()
        json[0]["result"].forEach { (key, quote) in
            let spread = self.calculateSpread(first: quote["2"].floatValue,
                                              second: quote["3"].floatValue)
            
            let newElement = QuoteStruct(name: quote["1"].stringValue,
                                         bid: quote["2"].floatValue,
                                         ask: quote["3"].floatValue,
                                         spread: spread)

            allQuotesArray.append(newElement)
            tableView.reloadData()
        }
    }
    
    func calculateSpread(first: Float?, second:
        Float?) -> Float {
        if let f = first, let s = second {
            return s - f;
        } else {
            return 0
        }
    }
    
}

//MARK: - UITableViewDataSource, UITableViewDelegate
extension OnlineQuotesController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allQuotesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! QuotesCell
        
        cell.quote.text = "\(allQuotesArray[indexPath.row].name)"
        cell.ask.text = "\(allQuotesArray[indexPath.row].ask)"
        cell.bid.text = "\(allQuotesArray[indexPath.row].bid)"
        cell.spread.text = "\(allQuotesArray[indexPath.row].spread)"
        
        if allQuotesArray[indexPath.row].spread > 0 {
            cell.symbol.image = UIImage(systemName: "arrow.up.right")
            cell.symbol.tintColor = .green
        } else {
            cell.symbol.image = UIImage(systemName: "arrow.down.left")
            cell.symbol.tintColor = .red
        }
        
        return cell
    }
    
    
}
