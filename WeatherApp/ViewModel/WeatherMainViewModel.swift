//
//  WeatherMainViewModel.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 23/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//

import Foundation
import CoreData
import UIKit
@objc protocol WeatherMainViewModelDelegate {
    @objc optional  func updateview(type:Int,indexPath:IndexPath)
}

class WeatherMainViewModel: NSObject {
    private var networkMan:NetworkManager
    private var parseManager:ParseManager
    private var urls = ["4163971", "2147714",
                "2174003"]
    private var coreDataManager = CoreDataManager()
    private var timer: Timer?
    var viewModeldelegate:WeatherMainViewModelDelegate?
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController <Weather> = {
        let fetchRequest =     NSFetchRequest<Weather>(entityName: "Weather")
        let sortDescriptor = NSSortDescriptor(key:  "city.name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let appdel = UIApplication.shared.delegate as! AppDelegate
        let context = appdel.persistentContainer.viewContext
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    override init() {
        networkMan = NetworkManager()
        parseManager = ParseManager()
        super.init()
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }
    }
    
    func getCitiesDataFromServer(completion:@escaping()->Void)
    {
        if (self.fetchedResultsController.fetchedObjects?.count)! < 1
        {
        for str in urls
        {
            let citiURL = APIBASEURL + "weather?id=\(str)&APPID=" + APIKEY
        networkMan.getDataFromServer(apiurl: citiURL) {[unowned self] (data, error) in
            guard let mydata = data
                else
            {
                print("error")
                return
            }
            let parsedDict:Dictionary = self.parseManager.parseJson(responseData: mydata)!
            //print("parsedDict=\(parsedDict)")
            let cid = parsedDict["id"] as? Int64
            let name = parsedDict["name"] as? String
            let weatherinfo = parsedDict["main"] as! NSDictionary
            
            let obj =  self.coreDataManager.saveCityinCoreData(cid: cid ?? 0, name: name ?? "")
            let _ = self.coreDataManager.saveWeatherinCoreData(weatherinfo: weatherinfo as! [String : Double], city: obj)
            completion()
            }
        }
    }
    else {completion()}
    }
    
    func startMonitoring()
    {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(weatherUpdate), userInfo: nil, repeats: true)
    }
    
    func stopMonitoring()
    {
        if(timer != nil)
        {
            timer?.invalidate()
            timer = nil
        }
    }
    func hasRecordsData()->Bool
    {
        if (self.fetchedResultsController.fetchedObjects?.count)! < 1
        {return false}
        else
        {return true}
        
    }
    @objc func weatherUpdate()
    {
        for str in urls
        {
            let citiURL = APIBASEURL + "weather?id=\(str)&APPID=" + APIKEY
            networkMan.getDataFromServer(apiurl: citiURL) {[unowned self] (data, error) in
                
                guard let mydata = data
                    else
                {
                    print("error")
                    return
                }
                
                let parsedDict:Dictionary = self.parseManager.parseJson(responseData: mydata)!
                var weatherinfo:[String : Double] = parsedDict["main"] as! [String : Double]
                let cid = parsedDict["id"] as? Int64

                let rhs = self.coreDataManager.getWeatherRecord(weatherinfo: weatherinfo)

                for obj in self.fetchedResultsController.fetchedObjects!
                {
                    let lhs = obj
                    if(lhs.city?.cid == cid )
                    {
                        //print(lhs.temp,rhs.temp)
                        if( (lhs == rhs) == false)
                        {
                            lhs.temp = weatherinfo["temp"] ?? 0
                            lhs.maxtemp = weatherinfo["temp_max"] ?? 0
                            lhs.mintemp = weatherinfo["temp_min"] ?? 0
                            self.coreDataManager.updateWeatherRecord(weather: lhs)
                        }
                    }
                }
                
            }
        }
    }
    
}

extension WeatherMainViewModel
{
    //MARK:
    func numberofRowsinSection(section:Int)->Int
    {
        if let sections = fetchedResultsController.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        
        return 0
    }
    
    func getObjectAtIndexPath(path:IndexPath)->Weather
    {
        let record = fetchedResultsController.object(at: path)
        return record
    }
}
extension WeatherMainViewModel:NSFetchedResultsControllerDelegate
{
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if newIndexPath != nil {
                viewModeldelegate?.updateview?(type: 1,indexPath: newIndexPath!)
            }
            break;
        case .update:
            if newIndexPath != nil {
            viewModeldelegate?.updateview?(type: 2,indexPath: newIndexPath!)
            }
            break;
        case .delete:
            if newIndexPath != nil {
                viewModeldelegate?.updateview?(type: 3,indexPath: newIndexPath!)
            }
            break;
        default:
            print("...")
        }
    }
}


