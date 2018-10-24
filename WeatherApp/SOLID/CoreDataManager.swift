//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 23/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class CoreDataManager: NSObject {
    
private lazy var appdel:AppDelegate = { return UIApplication.shared.delegate as! AppDelegate}()

    
    func saveCityinCoreData(cid:Int64,name:String)->Cities
    {
        let context = appdel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cities", in: context)
        let record:Cities = NSManagedObject(entity: entity!, insertInto: context) as! Cities
        record.name = name
        record.cid = cid
            do
            {
                try context.save()
            }
            catch
            {
                print("save to core data error")
            }
        return record
    }
    func saveWeatherinCoreData(weatherinfo:[String:Double], city:Cities)->Weather
    {
        let context = appdel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)
        let record:Weather = NSManagedObject(entity: entity!, insertInto: context) as! Weather
        record.humidity = weatherinfo["humidity"] ?? 0
        record.maxtemp = weatherinfo["temp_max"] ?? 0
        record.mintemp = weatherinfo["temp_min"] ?? 0
        record.temp = weatherinfo["temp"] ?? 0
        record.city = city
        do
        {
            try context.save()
        }
        catch
        {
            print("save to core data error")
        }
        return record
    }
    
    func updateWeatherRecord(weather:Weather)
    {
        do{
            try weather.managedObjectContext?.save()
        }
        catch
        {
            print("update error")
        }
    }
    
    func getWeatherRecord(weatherinfo:[String:Double])->Weather
    {
        let context = appdel.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Weather", in: context)

        let record:Weather = NSManagedObject(entity: entity!, insertInto: nil) as! Weather
        
        record.humidity = weatherinfo["humidity"] ?? 0
        record.maxtemp = weatherinfo["temp_max"] ?? 0
        record.mintemp = weatherinfo["temp_min"] ?? 0
        record.temp = weatherinfo["temp"] ?? 0
        return record
    }
}

