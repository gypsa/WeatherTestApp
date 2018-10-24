//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 24/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class WeatherDetailViewModel: NSObject {
    var weatherObj:Weather?
    fileprivate var weatherDataArray:[[String: Any]] = [[:]]
    
    func getObjectData() {
       weatherDataArray = weatherObj!.getObjectDictionary()
        //print(weatherDataArray)
    }

    func numberofRowsinSection(section:Int)->Int
    {
       return weatherDataArray.count

    }
    
    func getObjectAtIndexPath(path:IndexPath)->[String:Any]
    {
        return weatherDataArray[path.row]
    }
}
