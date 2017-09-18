//
//  HelperMethods.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

typealias alertViewButtonTapped = (_ index: Int, _ textFieldText: String?) -> Void

class HelperMethods: NSObject {

    ///  Shows UIAlertController pop over on selected controller
    ///
    /// - Parameters:
    ///   - viewController: viewcontroller which is visible viewcontroller
    ///   - title:  title of the alert controller
    ///   - message: message of the alert controller
    ///   - cancelButtonTitle:  cancel button title
    ///   - otherButtonTitles:  other button titles
    ///   - completionHandler:  call back method when user taps on the alet controller action buttons.
    
    class func showAlertController(presentController viewController: UIViewController?, _ title: String?, _ message: String?, _ cancelButtonTitle: String?, _ otherButtonTitles: [String]?, _ isPincodeShow: Bool?, completionHandler: alertViewButtonTapped?) -> Void {
        let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelTitle = cancelButtonTitle {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler: nil)
            controller.addAction(cancelAction)
        }
        
        if let titlesArray = otherButtonTitles {
            for (index,title) in titlesArray.enumerated() {
                let action = UIAlertAction(title: title, style: .default, handler: { (action) in
                    if completionHandler != nil {
                        if let textfield = controller.textFields?.first {
                            completionHandler!(index, textfield.text)
                        }else {
                            completionHandler!(index, nil)
                        }
                    }
                })
                controller.addAction(action)
            }
        }
        if isPincodeShow == true {
            controller.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Enter Pincode"
            })
        }
        if let vc: UIViewController = viewController {
            vc.present(controller, animated: true, completion: nil)
        }
    }
    
    /// this enum can be contains about identifiers of the views
    ///
    /// - pincodeViewController: pincode view controller storyboard identifier
    /// - hourlyTableViewCell: table view cell identifier
    /// - hourlyCollectionCell: collection view cell identifier
    enum  identifiers: String {
        case pincodeViewController = "PinCodeViewController"
        case hourlyTableViewCell = "hourlyCell"
        case hourlyCollectionCell = "hourlyCollectionCell"
    }
    
    struct ColorCodes {
        static let blueColor = UIColor(red: 3/255, green: 169/244, blue: 244/255, alpha: 1)
        static let orangeColor = UIColor(red: 255/255, green: 152/244, blue: 0/255, alpha: 1)
    }
    
    class func getLocationDetails() -> (String, String)? {
        if let location:[String: String] = UserDefaults.standard.object(forKey: "location") as? [String : String] {
            return (location["state"], location["city"]) as? (String, String)
        }
        return nil
    }
}
