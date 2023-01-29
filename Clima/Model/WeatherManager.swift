//
//  WeatherManager.swift
//  Clima
//
//  Created by Cyberlord on 1/28/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWheather(_ weatherManager: WeatherManager, weather: WeatherModal)
    
    func didFailedWithError(error : Error)
}



struct WeatherManager {
    
    let weatherURL = "http://api.openweathermap.org/data/2.5/weather?appid=&units=metric"
    
    
    var delegate: WeatherManagerDelegate?
    
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        print(urlString)
        
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    // Networking (Fetch Data)
    func performRequest(with getUrlString: String) {
        //1. Create Url.
        if let url = URL(string: getUrlString) {
            //2. Create URL Session
            let session = URLSession(configuration: .default)
            
            //3. Give URL Session task
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    self.delegate?.didFailedWithError(error: error!)
                    return
                }
                
                if let safeData = data {
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                    if let weather = self.parseJSON(safeData) {
//                        let weatherVC = WeatherViewController()
                        self.delegate?.didUpdateWheather(self, weather: weather)
                    }
                    
                    
                }
            }
            //4. Start task
            task.resume()
        }
        
        
    }
    
    // Parse Data into Swift Object to access Data.
    
    func parseJSON(_ weatherData: Data) -> WeatherModal? {
        let decoder = JSONDecoder()
        
        do {
            let decodeData = try decoder.decode(WeatherDataDecoded.self, from: weatherData)
//            print(decodeData.weather[0].description)
            let id = decodeData.weather[0].id
//            print(getConditionName(weatherId: id))
            
            let temp = decodeData.main.temp
            let name = decodeData.name
            
            let weather = WeatherModal(conditionId: id, cityName: name, temperature: temp)
//            print(weather.getConditionName(weatherId: id))
//            print(weather.conditionName)
            print(weather.temperature)
            return weather
            
        } catch {
            self.delegate?.didFailedWithError(error: error)
            return nil
        }
        
    }
    
    
    
    
}
