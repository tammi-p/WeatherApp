//
//  WeatherManager.swift
//  Clima
//
//  Created by Tammita Phongmekhin on 25/2/2563 BE.
//  Copyright © 2563 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}


struct WeatherManager {
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=ac72da2a4552a6b5d11096874dd94a57&units=metric" // https ensures secure connection (http does not)
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees) { // can have same function name as long as we have diff parameters
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) { // url is an optional url, so we use optional binding
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            // when task is done getting data off internet (this method allows us to do other things in the meantime), it triggers the trailing closure (only once this process of getting data from internet has completed). Then, we get access to the parameters (data, response, and error objects) it sends us.
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil { // Error (networking issues)
                    self.delegate?.didFailWithError(error: error!)
                    return // exit out of function and don't continue
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4. Start task
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        // the decode method could throw an error. Address this by using try/catch
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp)
            return weather
        } catch { // catch block catches the error (can't parse json)
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    
    
}
