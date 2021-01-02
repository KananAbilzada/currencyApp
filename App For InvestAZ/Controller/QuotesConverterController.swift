//
//  QuotesConverterController.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/27/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import UIKit
import Toast

class QuotesConverterController: UIViewController {
    @IBOutlet var currencies: [UIButton]!
    @IBOutlet weak var firstCurrencyText: UITextField!
    @IBOutlet weak var secondCurrencyText: UITextField!
    
    var currencyNames = [String]()
    let alert = AlertService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        secondCurrencyText.isUserInteractionEnabled = false
        
        getCurrencyList()
    }
    
    var firstCurrencyTitle: String? {
        get {
            return currencies[0].titleLabel?.text
        }
        set {
            return currencies[0].setTitle(newValue, for: .normal)
        }
    }

    var secondCurrencyTitle: String? {
        get {
            return currencies[1].titleLabel?.text
        }
        set {
            return currencies[1].setTitle(newValue, for: .normal)
        }
    }
    
    func getCurrencyList() {
        self.view.makeToastActivity(.center)
        NetworkManager.networkManager.getCurrencyList(endpoint: "/get_currency_list_for_app") { result in
            for (_, value) in result {
                let name = "\(value["code"])"
                self.currencyNames.append(name)
                self.view.hideToastActivity()
            }
            
            self.setDefaultCurrencyNames(first: self.currencyNames[3], second: self.currencyNames[13])
        }
    }
    
    private func setDefaultCurrencyNames(first: String, second: String) {
        firstCurrencyTitle = first
        secondCurrencyTitle = second
    }
    
    @IBAction func currencyChanged(_ sender: UIButton) {
        let buttonID = sender.tag
        
        let alertVC = alert.getLanguageSelectAlert(setTitle: "Choose Currency", ButtonName: "Ok", pickerData: currencyNames) {selected in
            
            switch buttonID {
            case 0:
                self.firstCurrencyTitle = selected
                
            case 1:
                self.secondCurrencyTitle = selected
            default:
                return
            }
            
            self.calculateCurrency()
        }
        
        present(alertVC, animated: true)
    }
    
    @IBAction func replaceCurrencies(_ sender: UIButton) {
        firstCurrencyTitle  = secondCurrencyTitle
        secondCurrencyTitle = firstCurrencyTitle
        
        firstCurrencyText.text  = secondCurrencyText.text
        
        delayAfter(seconds: 0.5) {
            self.calculateCurrency()
        }
    }
}

//MARK: - UITextFieldDelegate
extension QuotesConverterController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        calculateCurrency()
    }
    
    func calculateCurrency() {
        if let currencyValue = firstCurrencyText.text {
            if currencyValue != "" {
                let selectedCurrency = currencies[1].titleLabel!.text
                
                // converting process...
                NetworkManager.networkManager.convertCurrency(endpoint: "/get_currency_rate_for_app", mainCurrency: selectedCurrency!, dateTime: self.getNowTime()) { (result) in
                    
                    switch result {
                    case.success(let data):
                        data.filter { (arg0) -> Bool in
                            
                            let (_, json) = arg0
                            if "\(json["from"])" == self.currencies[0].titleLabel?.text {
                                let value = "\(json["result"])"

                                self.calculateUI(secondCurrencyValue: Float(value))
                            }
                            
                            return true
                        }
                        
                    case.failure(let error):
                        self.view.makeToast("\(error)")
                    }
                }
            }
        }
    }
    
    func calculateUI(secondCurrencyValue: Float?) {
        if firstCurrencyText!.text != "", let secondCurrency = secondCurrencyValue {
            secondCurrencyText.text = "\(Float(firstCurrencyText.text!)! * secondCurrency)"
        };
    }
}
