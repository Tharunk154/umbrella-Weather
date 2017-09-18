//
//  PinCodeViewController.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

class PinCodeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var pincode:String = UserDefaults.standard.object(forKey: "pincode") as? String ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()
        if pincode.characters.count == 0 {
            showPincodeAlertView()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK:- Private Methods
    
    fileprivate func customUI() {
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    fileprivate func showPincodeAlertView() {
        // Do any additional setup after loading the view.
        DispatchQueue.main.async {
            HelperMethods.showAlertController(presentController: self, "Enter Pincode here", nil, "Cancel", ["Done"], true, completionHandler: { (index, textFieldValue) in
                if index == 0 {
                    UserDefaults.standard.set(textFieldValue, forKey: "pincode")
                    self.pincode = UserDefaults.standard.object(forKey: "pincode") as? String ?? ""
                    self.tableView.reloadData()
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}

extension PinCodeViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pincode.characters.count == 0 ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.detailTextLabel?.text = pincode
        cell.textLabel?.text = "Zip"
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPincodeAlertView()
    }
}
