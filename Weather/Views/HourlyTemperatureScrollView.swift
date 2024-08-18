//
//  HourlyTemperatureView.swift
//  Weather
//
//  Created by bakeleet on 18/08/2024.
//

import UIKit


class HourlyTemperatureScrollView: UIScrollView {

    private var viewConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: [NSLayoutConstraint] = []

    private let stackView = UIStackView()

    func setup(safeArea: UILayoutGuide, bottomAnchor: NSLayoutYAxisAnchor) {
        backgroundColor = .systemBackground
        showsVerticalScrollIndicator = false

        translatesAutoresizingMaskIntoConstraints = false
        viewConstraints.append(topAnchor.constraint(equalTo: bottomAnchor))
        viewConstraints.append(leadingAnchor.constraint(equalTo: safeArea.leadingAnchor))
        viewConstraints.append(trailingAnchor.constraint(equalTo: safeArea.trailingAnchor))
        viewConstraints.append(heightAnchor.constraint(equalToConstant: 50))
        NSLayoutConstraint.activate(viewConstraints)
    }

    func setValues(of weather: Weather) {
        addSubview(stackView)

        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewConstraints.append(stackView.topAnchor.constraint(equalTo: topAnchor))
        stackViewConstraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor))
        stackViewConstraints.append(stackView.leadingAnchor.constraint(equalTo: leadingAnchor))
        stackViewConstraints.append(stackView.trailingAnchor.constraint(equalTo: trailingAnchor))
        stackViewConstraints.append(stackView.heightAnchor.constraint(equalTo: heightAnchor))
        NSLayoutConstraint.activate(stackViewConstraints)

        for hourly in weather.hourly {
            let hourlyView = HourlyTemperatureView()
            hourlyView.setValues(of: hourly)
            stackView.addArrangedSubview(hourlyView)
        }
    }
}
