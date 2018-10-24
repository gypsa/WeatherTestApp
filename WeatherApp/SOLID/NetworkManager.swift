//
//  NetworkManager.swift
//  WeatherApp
//
//  Created by Gypsa Agarwal on 23/10/18.
//  Copyright © 2018 Gypsa. All rights reserved.
//


import Foundation

class NetworkManager
{
    func getDataFromServer(apiurl:String,completion:@escaping(Data?,Error?)->Void)
    {
        let session = URLSession(configuration: .default)
        let apiurl = URL(string: apiurl)
        let dataTask = session.dataTask(with: apiurl!) { (data, response, error) in
            
            guard  error == nil
                else{
                    print("error=\(error?.localizedDescription ?? "server error")")
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                    return
            }
            guard let _ = (response as? HTTPURLResponse)?.statusCode
                else{
                    print("status code error=\((response as? HTTPURLResponse)?.statusCode ?? 0)")
                    DispatchQueue.main.async {
                        completion(nil,error)
                    }
                    return
            }
            guard let apidata = data
                else
            {
                print("data is nil")
                DispatchQueue.main.async {
                    completion(nil,error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(apidata,nil)
            }
            
        }
        dataTask.resume()
    }
}
