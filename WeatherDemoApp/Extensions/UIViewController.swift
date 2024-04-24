//
//  UIViewController.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import UIKit
import SVProgressHUD

extension UIViewController {
    
    // MARK: SVProgressHUD
    func showProgress() {
        SVProgressHUD.show()
    }
    
    @objc
    func hideProgress() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: Generic Alert
    /// Display an alert view if the function is not implemented
    func showAlert(title: String? = "Error", _ message: String?, selfDismissing: Bool = true, time: TimeInterval = 2){
        
        // Check if one has already presented
        if let currentAlert = self.presentedViewController as? UIAlertController {
            currentAlert.message = message
            return
        }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        self.present(alert, animated: true)
        
        if selfDismissing {
            Timer.scheduledTimer(withTimeInterval: time, repeats: false) { t in
                t.invalidate()
                alert.dismiss(animated: false)
            }
        }
    }
}
