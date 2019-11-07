//
//  ViewController.swift
//  WeatherApp
//
//  Created by Ilya Sokolov on 11/10/2019.
//  Copyright © 2019 Ilya Sokolov. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, getCityWeatherProtocol {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "45b40110d7c1f79b3a32607b61426f9a"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    //TODO: Declare instance variables here

    struct Weather {
        var temperature : Int
        var imageID : Int
        var image : String
        var city : String
    }
    var weather = Weather(temperature: 0, imageID: 0, image: "", city: "")
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    func getWeatherData(params: [String : String]) {
        Alamofire.request(WEATHER_URL, method: .get, parameters: params).responseJSON { (response) in
            if response.result.isSuccess {
                let weatherJSON : JSON = JSON(response.result.value!)
                self.updateWeatherData(json: weatherJSON)
            } else {
                print("error")
            }
        }
    }

    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(json: JSON) {
        print(json)
        weather.temperature = json["main"]["temp"].intValue - 273
        weather.imageID = json["weather"][0]["id"].intValue
        weather.city = json["name"].stringValue
        weather.image = weatherDataModel.updateWeatherIcon(condition: weather.imageID)
        
        updateUIWithWeatherData()
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    func updateUIWithWeatherData() {
        cityLabel.text = weather.city
        temperatureLabel.text = String(weather.temperature) + "°"
        weatherIcon.image = UIImage(named: weather.image)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String : String] = ["lat" : latitude , "lon" : longitude, "appid" : APP_ID]
            
            getWeatherData(params: params)
        }
    }
    
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func returnData(city: String) {
        let params : [String : String] = ["q" : city, "appid" : APP_ID]
        print(city)
        getWeatherData(params: params)
    }

    
    //Write the PrepareForSegue Method here
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName" {
            let vc = segue.destination as! ChangeCityViewController
            vc.delegate = self
        }
    }
    
    
    
    
}


