//
//  DailyTemperaturScrollView.swift
//  Weather
//
//  Created by bakeleet on 18/08/2024.
//

import UIKit


class DailyTemperatureScrollView: UIScrollView {

    private var viewConstraints: [NSLayoutConstraint] = []
    private var stackViewConstraints: [NSLayoutConstraint] = []

    private let stackView = UIStackView()

    func setup(safeArea: UILayoutGuide, otherViewBottomAnchor: NSLayoutYAxisAnchor) {
        backgroundColor = .systemBackground
        showsHorizontalScrollIndicator = false

        translatesAutoresizingMaskIntoConstraints = false
        viewConstraints.append(topAnchor.constraint(equalTo: otherViewBottomAnchor, constant: 30))
        viewConstraints.append(bottomAnchor.constraint(equalTo: safeArea.bottomAnchor))
        viewConstraints.append(leadingAnchor.constraint(equalTo: safeArea.leadingAnchor))
        viewConstraints.append(trailingAnchor.constraint(equalTo: safeArea.trailingAnchor))
        NSLayoutConstraint.activate(viewConstraints)
    }

    func setValues(of weather: Weather) {
        addSubview(stackView)

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 0

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackViewConstraints.append(stackView.topAnchor.constraint(equalTo: topAnchor))
        stackViewConstraints.append(stackView.bottomAnchor.constraint(equalTo: bottomAnchor))
        stackViewConstraints.append(stackView.leadingAnchor.constraint(equalTo: leadingAnchor))
        stackViewConstraints.append(stackView.trailingAnchor.constraint(equalTo: trailingAnchor))
        stackViewConstraints.append(stackView.widthAnchor.constraint(equalTo: widthAnchor))
        NSLayoutConstraint.activate(stackViewConstraints)

        for daily in weather.daily {
            let dailyView = DailyTemperatureView()
            dailyView.setValues(of: daily)
            stackView.addArrangedSubview(dailyView)
        }
    }
}
