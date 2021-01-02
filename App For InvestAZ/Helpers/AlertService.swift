//
//  AlertService.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/29/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import UIKit

class AlertService: UIViewController {
    
    func getLanguageSelectAlert(setTitle: String, ButtonName: String, pickerData: [String], completion: @escaping (_ selected: String) -> Void) -> CurrencySelector {
        
        let alertVC = self.getViewController(identifier: "CurrencySelector") as! CurrencySelector
        
        alertVC.setTitle = setTitle
        alertVC.pickerData = pickerData
        alertVC.setButtonName = ButtonName
        alertVC.buttonAction = completion
        
        return alertVC
    }
    
    func getViewController(identifier: String) ->UIViewController {
        let storyboard = UIStoryboard(name: "Alert", bundle: .main)
        let alertVC = storyboard.instantiateViewController(identifier: identifier)
        alertVC.modalPresentationStyle = .overFullScreen
        alertVC.modalTransitionStyle = .crossDissolve
        return alertVC
    }
}
