//
//  DetailsViewController.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import UIKit


class DetailsViewController: UIViewController {

    var selectedCity: City?

    private var weather: Weather? {
        didSet {
            guard let weather = weather, let selectedCity = selectedCity else {
                return
            }

            tempView.setValues(of: weather, for: selectedCity)
            hourlyTempView.setValues(of: weather)
        }
    }
    
    private let tempView = TemperatureView()
    private let hourlyTempView = HourlyTemperatureScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let city = selectedCity {
            Task {
                weather = await RESTManager.shared.getWeather(for: city)
            }
        }

        view.backgroundColor = .systemBackground

        view.addSubview(tempView)
        tempView.setup(safeArea: view.safeAreaLayoutGuide)

        view.addSubview(hourlyTempView)
        hourlyTempView.setup(safeArea: view.safeAreaLayoutGuide, bottomAnchor: tempView.bottomAnchor)
    }
}
