//
//  Weather+CoreDataClass.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 24/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//
//

import Foundation
import CoreData

public class Weather: NSManagedObject {

    
    static func ==(lhs: Weather, rhs: Weather) -> Bool {
        return lhs.temp == rhs.temp && lhs.maxtemp == rhs.maxtemp && lhs.mintemp == rhs.mintemp
    }
    
    func getObjectDictionary() -> [[String: Any]] {
        var dict: [String: Any] = [:]
        var myarr: [[String: Any]] = []
        for attribute in self.entity.attributesByName {
            //check if value is present, then add key to dictionary so as to avoid the nil value crash
            if let value = self.value(forKey: attribute.key) {
                dict["key"] = attribute.key
                dict["value"] = value
                myarr.append(dict)
            }
        }
        return myarr
    }
    
}

