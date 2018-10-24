//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 24/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//

import Foundation
import UIKit

class WeatherDetailViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var weatherDetailTableView:UITableView!

    var detailViewModel = WeatherDetailViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "WeatherTableCell", bundle: Bundle.main)
        self.weatherDetailTableView.register(nib, forCellReuseIdentifier: "detailcell")
        detailViewModel.getObjectData()
        self.weatherDetailTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailViewModel.numberofRowsinSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WeatherTableCell? = tableView.dequeueReusableCell(withIdentifier: "detailcell") as? WeatherTableCell
        
        let obj:[String:Any] = detailViewModel.getObjectAtIndexPath(path: indexPath)
        cell?.cityNameLbl!.text = obj["key"] as? String
        let aa = String(format: "%.2f", (obj["value"] as? Double)!)
        cell?.tempLbl!.text = aa
        return cell!
    }
}
