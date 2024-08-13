//
//  DetailsViewController.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import UIKit


class DetailsViewController: UIViewController {
    
    var selectedCity: City?
    private var weather: Weather?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let city = selectedCity {
            Task {
                weather = await RESTManager.shared.getWeather(for: city)
            }
        }
    }
}
