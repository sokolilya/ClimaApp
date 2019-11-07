//
//  ChangeCityViewController.swift
//  Clima
//
//  Created by Ilya Sokolov on 11/10/2019.
//  Copyright © 2019 Ilya Sokolov. All rights reserved.
//

import UIKit

protocol getCityWeatherProtocol {
    func returnData(city: String)
}

class ChangeCityViewController: UIViewController {
    
    var delegate : getCityWeatherProtocol?
    var city : String! = ""
    
    @IBOutlet weak var changeCityTextField: UITextField!
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        city = changeCityTextField.text
        if city != "" {
            delegate?.returnData(city: city)
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
