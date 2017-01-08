//
//  Weather.swift
//  favoritePlace
//
//  Created by Emre Dogan on 10/08/16.
//  Copyright © 2016 Emre Dogan. All rights reserved.
//

import Foundation


import Foundation

struct Weather {
    
    let dateAndTime: Date
    
    let city: String
    let country: String
   
    
    
    let mainWeather: String
    let weatherDescription: String
    let weatherStatus: String
    
    
    
    // OpenWeatherMap reports temperature in Kelvin,
    // which is why we provide celsius and fahrenheit
    // computed properties.
    fileprivate let temp: Double
    var tempCelsius: Double {
        get {
            return temp - 273.15
        }
    }
    var tempFahrenheit: Double {
        get {
            return (temp - 273.15) * 1.8 + 32
        }
    }
    
    
    // These properties are optionals because OpenWeatherMap doesn't provide:
    // - a value for wind direction when the wind speed is negligible
    // - rain info when there is no rainfall
    
    
    init(weatherData: [String: AnyObject]) {
        dateAndTime = Date(timeIntervalSince1970: weatherData["dt"] as! TimeInterval)
        city = weatherData["name"] as! String
        

        
        
        
        let weatherDict = weatherData["weather"]![0] as! [String: AnyObject]
        mainWeather = weatherDict["main"] as! String
        weatherDescription = weatherDict["description"] as! String
        weatherStatus = weatherDict["main"] as! String
        print("weatherStatus: \(weatherStatus)")
        

        let mainDict = weatherData["main"] as! [String: AnyObject]
        temp = mainDict["temp"] as! Double
       
        
     
        
       
        
        
        
        let sysDict = weatherData["sys"] as! [String: AnyObject]
        country = sysDict["country"] as! String
            }
    
}
