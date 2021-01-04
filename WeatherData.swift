//
//  WeatherData.swift
//  Clima
//
//  Created by Tammita Phongmekhin on 26/2/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import Foundation

struct WeatherData: Codable { // a WeatherData object is a type that can decode and encode itself from and to an external rep (in this case, the JSON format representation)
    let name: String
    let main: Main // in the webiste, main holds properties
    let weather: [Weather] // in the website, weather holds an array with 1 item that contains properties
    
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let id: Int
}
