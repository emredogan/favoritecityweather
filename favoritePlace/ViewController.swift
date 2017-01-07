//
//  ViewController.swift
//  favoritePlace
//
//  Created by Emre Dogan on 07/08/16.
//  Copyright © 2016 Emre Dogan. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
    WeatherGetterDelegate,
    UITextFieldDelegate
{
    
    
    
    
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    
    @IBOutlet weak var cityTextField: UILabel!
    
    
    @IBOutlet weak var weatherIcon: UIImageView!
    

    @IBOutlet weak var background: UIImageView!
    
    @IBOutlet weak var weatherBackground: UIView!
    
    var weather: WeatherGetter!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weatherBackground?.backgroundColor = UIColor(white: 1, alpha: 0.5)
        
        
        var diceRoll = Int(arc4random_uniform(3) + 1)
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let hour = calendar.component(.hour, from: date as Date)
        
        print("date: \(date)")
        print("hour: \(hour)")
        
        if hour > 19 {
            background.image = UIImage(named: "gece")
        } else if diceRoll == 0 {
            background.image = UIImage(named: "antalyagenel2")
        } else if diceRoll == 1 {
            background.image = UIImage(named: "antalyagenel")
        } else if diceRoll == 2 {
            background.image = UIImage(named: "antalyagenel3")
        } else if diceRoll == 3 {
            background.image = UIImage(named: "Antalya")
        } else {
            background.image = UIImage(named: "antalyagenel2")
        }
        
        
        
        
        
        
        weather = WeatherGetter(delegate: self)
        
        
        weatherLbl.text = ""
        tempLbl.text = ""
        
        weather.getWeather(cityTextField.text!.urlEncoded)
        
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func didGetWeather(_ weather: Weather) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        DispatchQueue.main.async {
            
            self.weatherLbl.text = weather.weatherDescription.capitalized
            self.tempLbl.text = "\(Int(round(weather.tempCelsius)))°"
            
            if self.weatherLbl.text == "Clear Sky" {
                self.weatherIcon.image = UIImage(named: "sun")
            } else if self.weatherLbl.text == "Few Clouds" {
                self.weatherIcon.image = UIImage(named: "cloud")
               // self.background.image = UIImage(named: "antalyabulutlu")
            } else if self.weatherLbl.text == "Scattered Clouds" {
                self.weatherIcon.image = UIImage(named: "cloud")
              //  self.background.image = UIImage(named: "antalyabulutlu")
            } else if self.weatherLbl.text == "Broken Clouds" {
                self.weatherIcon.image = UIImage(named: "cloud")
              //  self.background.image = UIImage(named: "antalyabulutlu")
            } else if self.weatherLbl.text == "Shower Rain" {
                self.weatherIcon.image = UIImage(named: "rain")
            } else if self.weatherLbl.text == "Rain" {
                self.weatherIcon.image = UIImage(named: "rain")
            } else if self.weatherLbl.text == "Thunderstorm" {
                self.weatherIcon.image = UIImage(named: "rain")
            } else if self.weatherLbl.text == "Snow" {
                self.weatherIcon.image = UIImage(named: "snow")
            } else if self.weatherLbl.text == "Mist" {
                self.weatherIcon.image = UIImage(named: "cloud")
            } else {
                
                self.weatherIcon.image = UIImage(named: "sun")
                
            }
            
            
            
            
            
            
            
        }
    }
    
    func didNotGetWeather(_ error: Error) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        DispatchQueue.main.async {
            self.showSimpleAlert(title: "Can't get the weather",
                                 message: "The weather service isn't responding.")
        }
        print("didNotGetWeather error: \(error)")
    }
    
    
    // MARK: - UITextFieldDelegate and related methods
    // -----------------------------------------------
    
    // Enable the "Get weather for the city above" button
    // if the city text field contains any text,
    // disable it otherwise.
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                                                 replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).replacingCharacters(
            in: range,
            with: string)
        
        print("Count: \(prospectiveText.characters.count)")
        return true
    }
    
    // Pressing the clear button on the text field (the x-in-a-circle button
    // on the right side of the field)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        // Even though pressing the clear button clears the text field,
        // this line is necessary. I'll explain in a later blog post.
        textField.text = ""
        
        
        return true
    }
    
    // Pressing the return button on the keyboard should be like
    // pressing the "Get weather for the city above" button.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Tapping on the view should dismiss the keyboard.
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Utility methods
    // -----------------------
    
    func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .default,
            handler: nil
        )
        alert.addAction(okAction)
        present(
            alert,
            animated: true,
            completion: nil
        )
    }

    
    
    


}


extension String {
    
    // A handy method for %-encoding strings containing spaces and other
    // characters that need to be converted for use in URLs.
    var urlEncoded: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlUserAllowed)!
    }
    
}

