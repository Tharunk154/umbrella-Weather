//
//  HourlyWeatherController.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

class HourlyWeatherController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var tableDataArray:[String:[HourlyModel]] = [String: [HourlyModel]]()
    var keysArray:[String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(HourlyTableViewCell.self, forCellReuseIdentifier: HelperMethods.identifiers.hourlyTableViewCell.rawValue)
        tableView.register(UINib(nibName: "HourlyTableViewCell", bundle: nil), forCellReuseIdentifier: HelperMethods.identifiers.hourlyTableViewCell.rawValue)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// update the weather frequently
    func updateHourlyWeather() {
        if let (state, city) = HelperMethods.getLocationDetails() {
            var keys:Set = Set<String>()
            NetworkManager.shared.getHourlyWeatherCondition(forState: state, forCity: city, completionHandler: { (hourlyResponse, response, error) in
                
                if error == nil {
                    
                    if let responseError: [String: AnyObject] =  hourlyResponse?["response"]?["error"] as? [String : AnyObject] {
                        // Error from service response.
                        DispatchQueue.main.async {
                            
                            HelperMethods.showAlertController(presentController: self, responseError["type"] as? String, responseError["description"] as? String, "Cancel", nil, false, completionHandler: nil)
                        }
                    }else {
                        let  hourlyWeather: [[String: AnyObject]] = (hourlyResponse!["hourly_forecast"] as? [[String : AnyObject]])!
                        self.tableDataArray.removeAll()
                        for element in hourlyWeather {
                            let day = element["FCTTIME"]?["yday"] as! String
                            let temp = element["temp"]?["english"] as! String
                            let civil = element["FCTTIME"]?["civil"] as! String
                            let imageURL = element["icon_url"] as! String
                            let weekDayName = element["FCTTIME"]?["weekday_name"] as! String
                            let modelObj = HourlyModel(withCivil: civil, temp, imageURL, day, weekDayName)
                            if var tempArray:[HourlyModel] = self.tableDataArray[day]{
                                tempArray.append(modelObj)
                                self.tableDataArray.updateValue(tempArray, forKey: day)
                            }else {
                                let newArray:[HourlyModel] = [modelObj]
                                self.tableDataArray.updateValue(newArray, forKey: day)
                            }
                            keys.insert(day)
                        }
                        self.keysArray = Array(keys)
                        self.keysArray.sort { $0.compare($1, options: .numeric) == .orderedAscending }
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    
                }else {
                    DispatchQueue.main.async {
                        HelperMethods.showAlertController(presentController: self, error?.localizedDescription, nil, "Cancel", nil, false, completionHandler: nil)
                    }
                }
            })
        }
    }
}

extension HourlyWeatherController: UITableViewDelegate,UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if keysArray.count > 0 {
            return keysArray.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HelperMethods.identifiers.hourlyTableViewCell.rawValue) as! HourlyTableViewCell
        let modelObj = tableDataArray[keysArray[indexPath.section]]?[indexPath.row]
        cell.dateLbl.text = modelObj?.weekDayName
        cell.updateCell(information: tableDataArray[keysArray[indexPath.section]]!)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 260
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
}
