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
    
    @IBOutlet weak var moreBtn: UIButton!
    
    
    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var tempLbl: UILabel!
    
    @IBOutlet weak var cityTextField: UILabel!
    
    

    @IBAction func moreButton(sender: AnyObject) {
    }
    
    var weather: WeatherGetter!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        
        
        weather = WeatherGetter(delegate: self)
        moreBtn.layer.cornerRadius == 2.0
        
        weatherLbl.text = ""
        tempLbl.text = ""
        
        weather.getWeather(cityTextField.text!.urlEncoded)
        
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didGetWeather(weather: Weather) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the code
        // that updates all the labels in a dispatch_async() call.
        dispatch_async(dispatch_get_main_queue()) {
            
            self.weatherLbl.text = weather.weatherDescription.capitalizedString
            self.tempLbl.text = "\(Int(round(weather.tempCelsius)))°"
            
            
            if let rain = weather.rainfallInLast3Hours {
            }
            else {
                
            }
            
        }
    }
    
    func didNotGetWeather(error: NSError) {
        // This method is called asynchronously, which means it won't execute in the main queue.
        // ALl UI code needs to execute in the main queue, which is why we're wrapping the call
        // to showSimpleAlert(title:message:) in a dispatch_async() call.
        dispatch_async(dispatch_get_main_queue()) {
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
    func textField(textField: UITextField,
                   shouldChangeCharactersInRange range: NSRange,
                                                 replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let prospectiveText = (currentText as NSString).stringByReplacingCharactersInRange(
            range,
            withString: string)
        
        print("Count: \(prospectiveText.characters.count)")
        return true
    }
    
    // Pressing the clear button on the text field (the x-in-a-circle button
    // on the right side of the field)
    func textFieldShouldClear(textField: UITextField) -> Bool {
        // Even though pressing the clear button clears the text field,
        // this line is necessary. I'll explain in a later blog post.
        textField.text = ""
        
        
        return true
    }
    
    // Pressing the return button on the keyboard should be like
    // pressing the "Get weather for the city above" button.
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // Tapping on the view should dismiss the keyboard.
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
    }
    
    
    // MARK: - Utility methods
    // -----------------------
    
    func showSimpleAlert(title title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .Alert
        )
        let okAction = UIAlertAction(
            title: "OK",
            style:  .Default,
            handler: nil
        )
        alert.addAction(okAction)
        presentViewController(
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
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLUserAllowedCharacterSet())!
    }
    
}

