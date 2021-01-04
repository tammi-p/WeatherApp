//
//  WeatherModel.swift
//  Clima
//
//  Created by Tammita Phongmekhin on 27/2/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import Foundation

struct WeatherModel {
    let conditionId: Int
    let cityName: String
    let temperature: Double

    var temperatureString: String { // Temperature as string with 1 decimal place
        return String(format: "%.1f", temperature)
    }
    
    var conditionName: String { // Determine value of variable conditionName
        switch conditionId {
        case ...232: // Thunderstorms
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500, 501, 520, 521 :
            return "cloud.rain"
        case 502...511, 522, 531:
            return "cloud.heavyrain"
        case 600...602:
            return "snow"
        case (611...613):
            return "cloud.sleet"
        case 615...622:
            return "cloud.snow"
        case 711:
            return "smoke"
        case 721:
            return "sun.haze"
        case 731, 761:
            return "sun.dust"
        case 701, 741: // Mist or Fog
            return "cloud.fog"
        case 781:
            return "tornado"
        case 800: // Clear
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
}
