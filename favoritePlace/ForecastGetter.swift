//
//  WeatherGetter.swift


import Foundation



protocol ForecastGetterDelegate {
    func didGetForecast(_ forecast: Forecast)
    func didNotGetForecast(_ error: Error)
}


// MARK: WeatherGetter
// ===================

class ForecastGetter {
    
    // api.openweathermap.org/data/2.5/forecast?q=
    
    fileprivate let openWeatherMapBaseURL = "http://api.openweathermap.org/data/2.5/forecast"
    fileprivate let openWeatherMapAPIKey = "ce6a7d2f658ebdbd775c6e15cbb16552"
    
    fileprivate var delegate: ForecastGetterDelegate
    
    
    // MARK: -
    
    init(delegate: ForecastGetterDelegate) {
        self.delegate = delegate
    }
    
    func getForecast(_ city: String) {
        
        
        
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
                self.delegate.didNotGetForecast(networkError)
            }
            else {
                print("Success")
                // Case 2: Success
                // We got data from the server!
                do {
                    // Try to convert that data into a Swift dictionary
                    let forecastData = try JSONSerialization.jsonObject(
                        with: responseData!  ,
                        options: .mutableContainers) as! [String: AnyObject]
                    
                    // If we made it to this point, we've successfully converted the
                    // JSON-formatted weather data into a Swift dictionary.
                    // Let's now used that dictionary to initialize a Weather struct.
                    let forecast = Forecast(forecastData: forecastData)
                    
                    print("forecast: \(forecast)")
                    
                    
                    
                    // Now that we have the Weather struct, let's notify the view controller,
                    // which will use it to display the weather to the user.
                    self.delegate.didGetForecast(forecast)
                }
                catch let jsonError as NSError {
                    // An error occurred while trying to convert the data into a Swift dictionary.
                    self.delegate.didNotGetForecast(jsonError)
                }
            }
            } as! (Data?, URLResponse?, Error?) -> Void)
        
        // The data task is set up...launch it!
        dataTask.resume()
    }
    
}

