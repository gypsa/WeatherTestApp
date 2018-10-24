//
//  ParseManager.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 23/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//


import Foundation

import Foundation
class ParseManager {
    
    func parseJson(responseData:Data)-> [String:AnyObject]?
    {
        do{
            let jsonResponse = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String:AnyObject]
            return jsonResponse
            
        }
        catch let error
        {
            print("parseJson error-\(error.localizedDescription)")
            
        }
        return [:]
    }
}
