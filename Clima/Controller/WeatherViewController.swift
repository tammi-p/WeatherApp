//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()

        // set self (Weather VC) as delegate of searchTextField, which responds to editing-related messages from the text field
        searchTextField.delegate = self
        weatherManager.delegate = self
        
    }
}

//MARK: - UITextFieldDelegate
extension WeatherViewController: UITextFieldDelegate {
    
    @IBAction func searchPressed(_ sender: UIButton) {
        searchTextField.endEditing(true) // tells program that we're done with editing, dismiss keyboard
    }
    
    // These are optional implementations. Check developer documentation to see their default implementations.
     
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }
    
    // Asks if editing should end (keyboard should be dismissed)
    // Is this only called when searchTextField.endEditing(true)? So in our code, when Search or Return buttons are pressed?
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        // if we want the following code to be performed for each text field (in this case we just have 1) when it's asking if its editing should end, just use textField.property rather than specificTextFieldName.property
        if textField.text != "" {
            return true
        }
        else {
            textField.placeholder = "Type something"
            return false
        }
    }
    
    // having a separate function for when editing ends (when keyboard is dismissed) is convenient bc we don't have to include the following code in both searchPressed and textFieldShouldReturn
    func textFieldDidEndEditing(_ textField: UITextField) {
        // use searchTextField.text to get weather for that city
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)

        }
        searchTextField.text = ""
    }
}

//MARK: - WeatherManagerDelegate
extension WeatherViewController: WeatherManagerDelegate {
       func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
           DispatchQueue.main.async {
               self.conditionImageView.image = UIImage(systemName: weather.conditionName)
               self.temperatureLabel.text = weather.temperatureString
               self.cityLabel.text = weather.cityName
           }
       }
       
       func didFailWithError(error: Error) {
           print(error)
       }
}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    
    @IBAction func locationButton(_ sender: UIButton) {
        locationManager.requestLocation() // location's weather data (which we get by the (*) locationManager(_manager...didUpdateLocations...) funcion) will update only when curr location has changed. We don't want that, so we have to add locationManager.stopUpdatingLocation() in the (*) function
    }
    
    // (*)
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            weatherManager.fetchWeather(latitude: lat, longitude: lon)
        }

    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
