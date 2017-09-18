//
//  HourlyTableViewCell.swift
//  Umbrella
//
//  Created by Tharun K on 17/09/17.
//  Copyright © 2017 Tharun K. All rights reserved.
//

import UIKit

class HourlyTableViewCell: UITableViewCell {

    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataArray: [HourlyModel]? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        layer.cornerRadius = 4.0
        layer.masksToBounds = true
    
        collectionView.register(HourlyCollectionViewCell.self, forCellWithReuseIdentifier: HelperMethods.identifiers.hourlyCollectionCell.rawValue)
        collectionView.register(UINib(nibName: "HourlyCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HelperMethods.identifiers.hourlyCollectionCell.rawValue)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateCell(information hourlyObjArray: [HourlyModel]) {
        
        self.dataArray = hourlyObjArray
        collectionView.reloadData()
    }
}

extension HourlyTableViewCell: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = dataArray?.count {
            return count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HelperMethods.identifiers.hourlyCollectionCell.rawValue, for: indexPath) as! HourlyCollectionViewCell
        let hourlyModel = dataArray?[indexPath.row]
        cell.updateCollectionViewCell(hourlyModel!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 100)
    }
}
