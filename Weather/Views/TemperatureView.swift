//
//  TemperatureView.swift
//  Weather
//
//  Created by bakeleet on 18/08/2024.
//

import UIKit


class TemperatureView: UIView {

    private var viewConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: [NSLayoutConstraint] = []

    private let cityLabel = UILabel()
    private let tempLabel = UILabel()
    private let stackView = UIStackView()

    func setup(safeArea: UILayoutGuide) {
        backgroundColor = .systemBackground

        translatesAutoresizingMaskIntoConstraints = false
        viewConstraints.append(topAnchor.constraint(equalTo: safeArea.topAnchor))
        viewConstraints.append(leadingAnchor.constraint(equalTo: safeArea.leadingAnchor))
        viewConstraints.append(trailingAnchor.constraint(equalTo: safeArea.trailingAnchor))
        viewConstraints.append(heightAnchor.constraint(equalToConstant: 160))
        NSLayoutConstraint.activate(viewConstraints)

        setupStackView()
    }

    func setValues(of weather: Weather, for city: City) {
        cityLabel.text = city.name
        tempLabel.text = "\(weather.current.temp) °C"
    }

    private func setupStackView() {
        addSubview(stackView)
        stackView.addArrangedSubview(cityLabel)
        stackView.addArrangedSubview(tempLabel)
        
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewConstraints.append(stackView.centerXAnchor.constraint(equalTo: centerXAnchor))
        stackViewConstraints.append(stackView.centerYAnchor.constraint(equalTo: centerYAnchor))
        stackViewConstraints.append(stackView.heightAnchor.constraint(equalTo: heightAnchor, constant: -40))
        stackViewConstraints.append(stackView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40))
        NSLayoutConstraint.activate(stackViewConstraints)

        cityLabel.font = .systemFont(ofSize: 20)
        tempLabel.font = .systemFont(ofSize: 40)
    }
}
