//
//  NetworkManager.swift
//  RestCountriesApp
//
//  Created by jazeps.ivulis on 16/05/2023.
//

import Foundation

class NetworkManager {
    
    static func fetchData(url: String, completion: @escaping ([Country]) -> () ) {
        
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let config = URLSessionConfiguration.default
        config.waitsForConnectivity = true
        
        URLSession(configuration: config).dataTask(with: request) { (data, response, err) in
            
            guard err == nil else {
                print("error: ", err!)
                return
            }
            
            print("response: ", response as Any)
            
            guard let data = data else { return }
            
            do {
                let jsonData = try JSONDecoder().decode([Country].self, from: data)
                completion(jsonData)
            }catch{
                print("error: ", error)
            }
            
        }.resume()
    }
}
