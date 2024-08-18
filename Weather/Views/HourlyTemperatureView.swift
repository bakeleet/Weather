//
//  HourlyTemperatureView.swift
//  Weather
//
//  Created by bakeleet on 18/08/2024.
//

import UIKit


class HourlyTemperatureView: UIStackView {
    
    private var viewConstraints: [NSLayoutConstraint] = []

    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH"
        return formatter
    }()

    private let hourLabel = UILabel()
    private let tempLabel = UILabel()
    private let stackView = UIStackView()

    func setValues(of weather: Current) {
        setupStackView()

        let time = Date(timeIntervalSince1970: Double(weather.dt))
        hourLabel.text = timeFormatter.string(from: time)
        tempLabel.text = weather.formatTemperature()
        tempLabel.textColor = Weather.temperatureColor(for: weather.temp)
    }

    private func setupStackView() {
        backgroundColor = .systemBackground

        addSubview(stackView)
        stackView.addArrangedSubview(hourLabel)
        stackView.addArrangedSubview(tempLabel)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewConstraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
        viewConstraints.append(stackView.centerYAnchor.constraint(equalTo: centerYAnchor))
        viewConstraints.append(stackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -15))
        viewConstraints.append(stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -15))
        NSLayoutConstraint.activate(viewConstraints)

        hourLabel.font = .systemFont(ofSize: 12)
        tempLabel.font = .systemFont(ofSize: 14)
    }
}
