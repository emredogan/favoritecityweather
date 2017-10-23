//
//  WeatherGetter.swift
//

import Foundation

protocol WeatherGetterDelegate {
    func didGetWeather(_ weather: Weather)
    func didNotGetWeather(_ error: Error)
}



class WeatherGetter {
    
   // api.openweathermap.org/data/2.5/forecast?q=
    
    fileprivate let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/weather"
    fileprivate let openWeatherMapAPIKey = "ce6a7d2f658ebdbd775c6e15cbb16552"
    
    fileprivate var delegate: WeatherGetterDelegate
    
    
    // MARK: -
    
    init(delegate: WeatherGetterDelegate) {
        self.delegate = delegate
    }
    
    func getWeather(_ city: String) {
        
        
        
        // This is a pretty simple networking task, so the shared session will do.
        let session = URLSession.shared
        
        let weatherURL = URL(string: "\(openWeatherMapBaseURL)?APPID=\(openWeatherMapAPIKey)&q=\(city)")!
        
        print("weatherurl: \(weatherURL)")
        
        var weatherRequestURL = URLRequest(url: weatherURL)
        
        weatherRequestURL.httpMethod = "Post"
        
        // The data task retrieves the data.
        let dataTask = URLSession.shared.dataTask(with: weatherRequestURL, completionHandler: { (responseData:Data?,
            response:URLResponse?,
            error:Error?) -> Void in
            if let networkError = error {
                // Case 1: Error
                // An error occurred while trying to get data from the server.
                self.delegate.didNotGetWeather(networkError)
            }
            else {
                print("Success")
                // Case 2: Success
                // We got data from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let weatherData = try JSONSerialization.jsonObject(
                        with: responseData!  ,
                        options: .mutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let weather = Weather(weatherData: weatherData)
                    
                    
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetWeather(weather)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.didNotGetWeather(jsonError)
                }
            }
        } as! (Data?, URLResponse?, Error?) -> Void)
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}

