//
//  Weather+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 24/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//
//

import Foundation
import CoreData


extension Weather {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weather> {
        return NSFetchRequest<Weather>(entityName: "Weather")
    }

    @NSManaged public var humidity: Double
    @NSManaged public var maxtemp: Double
    @NSManaged public var mintemp: Double
    @NSManaged public var temp: Double
    @NSManaged public var city: Cities?

}
