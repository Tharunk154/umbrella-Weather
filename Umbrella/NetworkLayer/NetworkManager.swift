//
//  NetworkManager.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

enum ServiceURLs: String {
    case geolookup = "http://api.wunderground.com/api/8068ed0167cf004c/geolookup/q/"
    case conditions = "http://api.wunderground.com/api/8068ed0167cf004c/conditions/q/"
    case hourly = "http://api.wunderground.com/api/8068ed0167cf004c/hourly/q/"
}

typealias networkHandler = (_ jsonResponse: [String: AnyObject]?, _ response: URLResponse?, _ error: Error?) -> Void

class NetworkManager: NSObject {

    /// Single Instance for the class
    static let shared: NetworkManager = NetworkManager()
    
    /// session object is creates only once
    lazy var session: URLSession = {
        var configuration: URLSessionConfiguration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        let session = URLSession(configuration: configuration)
        return session
    }()
    
    override private init() {
        super.init()
    }
    
    /// This service call can be used to fetch the city name, zip code / postal code, latitude-longitude coordinates and nearby personal weather stations.
    ///
    /// - Parameters:
    ///   - pincode: pincode of the city
    ///   - completionHandler:  returns the json data to the controller.
    func getGeolookup(forPincode pincode: String, completionHandler: @escaping networkHandler) {
        let url = ServiceURLs.geolookup.rawValue+"\(pincode).json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dataTask = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    if let jsonData = data {
                        let json:[String: AnyObject] = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : AnyObject]
                        debugPrint("JSON: \(#function): \(json)")
                        if let lcoationResponse: [String: AnyObject] = json["location"] as? [String : AnyObject] {
                            self.parseGeolookupResponse(lcoationResponse)
                        }
                        completionHandler(json, response, nil)
                    }
                }else {
                    debugPrint("Error: \(#function)")
                    completionHandler(nil, response, nil)
                }
            }else {
                debugPrint("Error: \(String(describing: error))")
                completionHandler(nil, response, error)
            }
        }
        dataTask.resume()
    }
    
    /// This service call can be used to fetch the current conditions of the city.
    ///
    /// - Parameters:
    ///   - state: state `code
    ///   - city: city name
    ///   - completionHandler: returns the json data to the controller
    func getCurrentWeatherCondition(forState state: String, forCity city: String, completionHandler: @escaping networkHandler) {
        let url = ServiceURLs.conditions.rawValue+"\(state)/\(city).json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dataTask = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    if let jsonData = data {
                        let json:[String: AnyObject] = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : AnyObject]
                        debugPrint("JSON: \(#function): \(json)")
                        if let currentWeather: [String: AnyObject] = json["current_observation"] as? [String : AnyObject] {
                            completionHandler(currentWeather, response, nil)
                        }
                    }
                }else {
                    debugPrint("Error: \(#function)")
                    completionHandler(nil, response, nil)
                }
            }else {
                debugPrint("Error: \(String(describing: error))")
                completionHandler(nil, response, error)
            }
        }
        dataTask.resume()
    }
    
    /// hourly weather report
    ///
    /// - Parameters:
    ///   - state: state parameter
    ///   - city: city parameter
    ///   - completionHandler: returns the json data to the controller
    func getHourlyWeatherCondition(forState state: String, forCity city: String, completionHandler: @escaping networkHandler) {
        let url = ServiceURLs.hourly.rawValue+"\(state)/\(city).json".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let dataTask = session.dataTask(with: URL(string: url)!) { (data, response, error) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if error == nil {
                let httpResponse: HTTPURLResponse = response as! HTTPURLResponse
                if httpResponse.statusCode == 200 {
                    if let jsonData = data {
                        let json:[String: AnyObject] = try! JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) as! [String : AnyObject]
                        debugPrint("JSON: \(#function): \(json)")
                        completionHandler(json, response, nil)
                    }
                }else {
                    debugPrint("Error: \(#function)")
                    completionHandler(nil, response, nil)
                }
            }else {
                debugPrint("Error: \(String(describing: error))")
                completionHandler(nil, response, error)
            }
        }
        dataTask.resume()
    }

    fileprivate func parseGeolookupResponse(_ locationResponse: [String: AnyObject]) {
        let state = locationResponse["state"] as! String
        let city = locationResponse["city"] as! String
        let dict = ["city": city, "state": state]
        UserDefaults.standard.set(dict, forKey: "location")
    }
}
