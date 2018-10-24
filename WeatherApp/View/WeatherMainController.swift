//
//  WeatherMainController.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 23/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//

import Foundation
import UIKit

class WeatherMainController: UIViewController,UITableViewDataSource,UITableViewDelegate,WeatherMainViewModelDelegate{
    
    var viewModel = WeatherMainViewModel()
    @IBOutlet weak var weatherTableView:UITableView!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Weather"
        let nib = UINib(nibName: "WeatherTableCell", bundle: Bundle.main)
        self.weatherTableView.register(nib, forCellReuseIdentifier: "tempcell")
        viewModel.viewModeldelegate = self
        activityIndicatorView.startAnimating()

        viewModel.getCitiesDataFromServer {
        [unowned self] in
            self.activityIndicatorView.stopAnimating()
        }
            
    }
    override func viewDidAppear(_ animated: Bool) {
        viewModel.startMonitoring()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        viewModel.stopMonitoring()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberofRowsinSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:WeatherTableCell? = tableView.dequeueReusableCell(withIdentifier: "tempcell") as? WeatherTableCell
  
        let obj = viewModel.getObjectAtIndexPath(path: indexPath)
        cell?.cityNameLbl!.text = (obj.city?.name)!
        let aa = String(format: "%.2f", obj.temp)
        cell?.tempLbl!.text = aa
        return cell!
    }
    
    func updateview(type:Int,indexPath:IndexPath)
    {
        switch type {
        case 1:
        self.weatherTableView.insertRows(at: [indexPath], with: .fade)
        case 2:
            self.weatherTableView.reloadRows(at: [indexPath], with: .fade)
        case 3:
            self.weatherTableView.deleteRows(at: [indexPath], with: .fade)
        default:
           self.weatherTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        self.performSegue(withIdentifier: "detailSegue", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"
        {
            let nextscene = segue.destination as? WeatherDetailViewController
            let obj = viewModel.getObjectAtIndexPath(path: sender as! IndexPath)
            nextscene?.detailViewModel.weatherObj = obj
            nextscene?.title = (obj.city?.name)!
        }
    }
}
