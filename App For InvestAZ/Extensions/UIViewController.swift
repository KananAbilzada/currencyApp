//
//  UIViewController.swift
//  App For InvestAZ
//
//  Created by Kanan`s Macbook Pro on 12/27/20.
//  Copyright © 2020 Kanan`s Macbook Pro. All rights reserved.
//

import UIKit

@nonobjc extension UIViewController {
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)

        if let frame = frame {
            child.view.frame = frame
        }

        view.addSubview(child.view)
        child.didMove(toParent: self)
    }

    func remove(previousController: UIViewController) {
        previousController.willMove(toParent: nil)
        previousController.view.removeFromSuperview()
        previousController.removeFromParent()
    }
}


extension UIViewController {
    func delayAfter(seconds delay: Double, closure: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    func getNowTime() -> String {
        let date = Date()
        let calendar = Calendar.current
        
        let years = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day   = calendar.component(.day, from: date)
        
        return "\(years)-\(month)-\(day)"
    }
}
