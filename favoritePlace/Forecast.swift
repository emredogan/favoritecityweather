//
//  Forecast.swift
//  favoritePlace
//
//  Created by Emre Dogan on 07/01/17.
//  Copyright © 2017 Emre Dogan. All rights reserved.
//

import Foundation

struct Forecast {
    

    
    let tomorrowWeather: String
    
    let tomorrowWeatherMain: String
    
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
    
    
    init(forecastData: [String: AnyObject]) {
        
        if forecastData.isEmpty {
            
            temp = 273
            tomorrowWeatherMain = ""
            tomorrowWeather = ""
            
            
        } else if forecastData.count == 2 {
            
            temp = 273
            tomorrowWeatherMain = ""
            tomorrowWeather = ""
            
        }
            
            
        else {
            
            
            print("forecastData: \(forecastData)")
            print("count: \(forecastData.count)")
            
            
            
           
            
            let forecastDict = forecastData["list"]![1] as! [String:AnyObject]
            
            print("forecastDict: \(forecastDict)")
            
            let forecastDictMain = forecastDict["main"] as! [String:AnyObject]
            
            temp = forecastDictMain["temp"] as! Double
            
            
            
            
            let tomorrow = forecastDict["weather"]
            print("tomorrow: \((tomorrow)!)")
            
            let tomorrowWeatherDict = tomorrow![0] as! [String:AnyObject]
            
            print("tomorrowWeatherDict: \(tomorrowWeatherDict)")
            
            tomorrowWeather = tomorrowWeatherDict["description"] as! String
            
            print("tomorrowWeather: \(tomorrowWeather)")
            
            tomorrowWeatherMain = tomorrowWeatherDict["main"] as! String
            
            print("tomorrowWeatherMain: \(tomorrowWeatherMain)")
            
        }
        
        
        
        
        
        
        
        
        
        
        
        
       
    
    
}

}
