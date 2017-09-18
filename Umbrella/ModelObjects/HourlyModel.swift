//
//  HourlyModel.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

class HourlyModel: NSObject {

    var civil: String = ""
    var temp:String = ""
    var iconUrl:String = ""
    var yday:String = ""
    var weekDayName: String = ""
    init(withCivil civil: String, _ temp: String, _ iconURL:String, _ day:String, _ weekDayName: String) {
        self.civil = civil
        self.temp = temp
        self.iconUrl = iconURL
        self.yday = day
        self.weekDayName = weekDayName
    }
}
