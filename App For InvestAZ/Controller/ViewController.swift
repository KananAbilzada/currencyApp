//
//  ViewController.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/27/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import UIKit

class ViewController: BaseVC {    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delayAfter(seconds: 0.1) {
            self.getInitialVC()
        }
    }
    
    @IBAction func segmentChanged(_ sender: UISegmentedControl) {
        
        var identifier: String?
        var storyboard: String?
        
        switch sender.selectedSegmentIndex {
        case 0:
            identifier = "QuotesConverterController"
            storyboard = "QuotesConverter"
            
        case 1:
            identifier = "OnlineQuotesController"
            storyboard = "OnlineQuote"
            
        default:
            return;
        }
        
        delayAfter(seconds: 0.1) {
            self.remove(previousController: self.children[0])
            self.getInitialVC(identifier: identifier!, storyboard: storyboard!)
        }
        
    }
    
}

class BaseVC: UIViewController {
    func getInitialVC(identifier: String? = "QuotesConverterController", storyboard: String? = "QuotesConverter") {
        let vc = self.getController(id: identifier!, storyboard: storyboard!) 
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .crossDissolve
        self.add(vc, frame: self.view.frame)
    }
    
    func getController(id: String, storyboard: String) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: id)
    }
}

