//
//  DailyTemperatureView.swift
//  Weather
//
//  Created by bakeleet on 18/08/2024.
//

import UIKit


class DailyTemperatureView: UIStackView {
    
    private var viewConstraints: [NSLayoutConstraint] = []

    private var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    private let dateLabel = UILabel()
    private let minLabel = UILabel()
    private let maxLabel = UILabel()
    private let stackView = UIStackView()

    func setValues(of weather: Daily) {
        setupStackView()

        let dt = Date(timeIntervalSince1970: Double(weather.dt))
        dateLabel.text = timeFormatter.string(from: dt)
        minLabel.text = weather.temp.formatMinTemperature()
        minLabel.textColor = Weather.temperatureColor(for: weather.temp.min)
        maxLabel.text = weather.temp.formatMaxTemperature()
        maxLabel.textColor = Weather.temperatureColor(for: weather.temp.max)
    }

    private func setupStackView() {
        backgroundColor = .systemBackground

        addSubview(stackView)
        stackView.addArrangedSubview(dateLabel)
        
        let minMaxStackView = UIStackView()
        minMaxStackView.addArrangedSubview(minLabel)
        minMaxStackView.addArrangedSubview(maxLabel)
        minMaxStackView.spacing = 10
        stackView.addArrangedSubview(minMaxStackView)
        
        
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        viewConstraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
        viewConstraints.append(stackView.centerYAnchor.constraint(equalTo: centerYAnchor))
        viewConstraints.append(stackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -15))
        viewConstraints.append(stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -15))
        NSLayoutConstraint.activate(viewConstraints)

        dateLabel.font = .systemFont(ofSize: 12)
        minLabel.font = .systemFont(ofSize: 14)
        maxLabel.font = .systemFont(ofSize: 14)
    }
}
