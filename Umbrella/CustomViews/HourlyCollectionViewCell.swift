//
//  HourlyCollectionViewCell.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

class HourlyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tempLbl: UILabel!
    @IBOutlet weak var civilLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        civilLbl.adjustsFontSizeToFitWidth = true
    }

    func updateCollectionViewCell(_ hourlyModel: HourlyModel) {
        tempLbl.text = hourlyModel.temp
        civilLbl.text = hourlyModel.civil
        if let url = URL(string: hourlyModel.iconUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!) {
            let downloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                if error == nil {
                    if let image = UIImage(data: data!) {
                        DispatchQueue.main.async {
                            self.imageView.image = image
                        }
                    }
                }
            })
            downloadTask.resume()
        }
    }
}
