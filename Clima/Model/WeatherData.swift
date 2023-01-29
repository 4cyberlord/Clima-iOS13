//
//  WeatherData.swift
//  Clima
//
//  Created by Cyberlord on 1/28/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation



struct WeatherDataDecoded: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}


struct Main: Decodable {
    let temp: Double
}


struct Weather: Decodable {
    let description: String
    let id: Int
}
