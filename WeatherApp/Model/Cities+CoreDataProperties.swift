//
//  Cities+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 24/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//
//

import Foundation
import CoreData


extension Cities {

    @nonobjc public class func cityfetchRequest() -> NSFetchRequest<Cities> {
        return NSFetchRequest<Cities>(entityName: "Cities")
    }

    @NSManaged public var cid: Int64
    @NSManaged public var name: String?
    @NSManaged public var weather: Weather?

}
