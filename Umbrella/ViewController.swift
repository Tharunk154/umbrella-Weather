//
//  ViewController.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var statusLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var bottomView: UIView!
    var hourlyVc: HourlyWeatherController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        loadingView.isHidden = true
        let pincode:String = UserDefaults.standard.object(forKey: "pincode") as? String ?? ""
        if pincode.characters.count == 0 {
            navigateToPincodeViewController()
        }
        customUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true

        if let pincode:String = UserDefaults.standard.object(forKey: "pincode") as? String {
            locationDetails(forPincode: pincode)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK:- Private Methods
    fileprivate func customUI() {
        view.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        if let hourVc =  childViewControllers.first as? HourlyWeatherController {
            self.hourlyVc = hourVc
        }
    }
    
    /// this method can be used to get the location details about the pincode
    ///
    /// - Parameter pincode: pincode
    fileprivate func locationDetails(forPincode pincode: String) {
        startLoadingView()
        NetworkManager.shared.getGeolookup(forPincode: pincode) { (jsonResponse, response, error) in
            self.stopLoadingView()
            
            if error == nil {
                if let responseError: [String: AnyObject] =  jsonResponse?["response"]?["error"] as? [String : AnyObject] {
                    // Error from service response.
                    DispatchQueue.main.async {
        
                        HelperMethods.showAlertController(presentController: self, responseError["type"] as? String, responseError["description"] as? String, "Cancel", nil, false, completionHandler: nil)
                    }
                }else {
                    self.currentConditionWeather()
                }
            }else {
                DispatchQueue.main.async {
                    HelperMethods.showAlertController(presentController: self, error?.localizedDescription, nil, "Cancel", nil, false, completionHandler: nil)
                }
            }
        }
    }
    
    ///  this method can be used to get the current weather report based on entered pincode
    fileprivate func currentConditionWeather() {
        startLoadingView()
        if let location:[String: String] = UserDefaults.standard.object(forKey: "location") as? [String : String] {
            NetworkManager.shared.getCurrentWeatherCondition(forState: location["state"]!, forCity: location["city"]!) { (jsonResponse, response, error) in
                self.stopLoadingView()

                if error == nil {
                    if let responseError: [String: AnyObject] =  jsonResponse?["response"]?["error"] as? [String : AnyObject] {
                        // Error from service response.
                        DispatchQueue.main.async {
                            
                            HelperMethods.showAlertController(presentController: self, responseError["type"] as? String, responseError["description"] as? String, "Cancel", nil, false, completionHandler: nil)
                        }
                    }else {
                        self.hourlyVc?.updateHourlyWeather()
                        DispatchQueue.main.async {
                            self.updateTopView(jsonResponse!)
                        }
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        HelperMethods.showAlertController(presentController: self, error?.localizedDescription, nil, "Cancel", nil, false, completionHandler: nil)
                    }
                }
            }
        }
        
    }
    
    ///  This method can be used to update the values of the weather information about the pincode location
    ///
    /// - Parameter weatherInfo: weather information
    fileprivate func updateTopView(_ weatherInfo: [String: AnyObject]) {
        if let displayLocation:[String: AnyObject] = weatherInfo["display_location"] as? [String: AnyObject] {
            cityLbl.text = displayLocation["full"] as? String
        }
        if let weather =  weatherInfo["weather"] as? String {
            statusLbl.text = weather
        }
        if let temp = weatherInfo["temp_f"] as? Float {
            if temp > 60.0 {
                topView.backgroundColor = HelperMethods.ColorCodes.orangeColor
            }else {
                topView.backgroundColor = HelperMethods.ColorCodes.blueColor
            }
            tempLbl.text = String(temp)
        }
    }
    
    fileprivate func navigateToPincodeViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let pincodeVc = storyboard.instantiateViewController(withIdentifier: HelperMethods.identifiers.pincodeViewController.rawValue)
        navigationController?.pushViewController(pincodeVc, animated: true)
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        navigateToPincodeViewController()
    }
    
    ///  This method can be used to show the activity indicator
    fileprivate func startLoadingView() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadingView.isHidden = false
        loadingView.startAnimating()
    }
    
    /// this method can be used to stop the activity indicator and hides
    fileprivate func stopLoadingView() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self.loadingView.isHidden = true
            self.loadingView.stopAnimating()
        }
    }
}

