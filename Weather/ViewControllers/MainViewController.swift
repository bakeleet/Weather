//
//  ViewController.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import UIKit


class MainViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    
    private var searchTask: Task<(), Error>?
    private var cities: [String: City] = [:]
    private var citiesKeys: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true

        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        loadSavedData()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let currentKey = citiesKeys[indexPath.row]
        if let city = cities[currentKey] {
            cell.textLabel!.text = "\(city.name), \(city.state), \(city.country)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsViewController()
        let currentKey = citiesKeys[indexPath.row]
        let selectedCity = cities[currentKey]
        detailVC.selectedCity = selectedCity
        navigationController?.pushViewController(detailVC, animated: true)
        
        saveData(selectedCity)
    }
    
    private func saveData(_ city: City?) {
        guard let selectedCity = city else { return }
        do {
            if let data = UserDefaults.standard.object(forKey: "savedCities") as? Data {
                var savedCities = try JSONDecoder().decode([String: City].self, from: data)
                savedCities[selectedCity.name] = selectedCity
                let citiesData = try JSONEncoder().encode(savedCities)
                UserDefaults.standard.set(citiesData, forKey: "savedCities")
            } else {
                let firstCity = [selectedCity.name: selectedCity]
                let data = try JSONEncoder().encode(firstCity)
                UserDefaults.standard.set(data, forKey: "savedCities")
            }
        } catch {
            print("[E] MainViewController - JSONEncoder error: \(error)")
        }
    }
    
    private func loadSavedData() {
        if let data = UserDefaults.standard.object(forKey: "savedCities") as? Data {
            do {
                cities = try JSONDecoder().decode([String: City].self, from: data)
                citiesKeys = Array(cities.keys)
            } catch {
                print("[E] MainViewController - JSONDecoder error: \(error)")
            }
        }
    }
}

extension MainViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text, !searchText.isEmpty {
            let strippedSearchText = searchText.folding(options: .diacriticInsensitive,
                                                        locale: Locale(identifier: "en_US"))

            if let task = searchTask {
                task.cancel()
            }
            searchTask = Task {
                try await Task.sleep(nanoseconds: 300_000_000)
                let searchedCities = await RESTManager.shared.getCities(for: strippedSearchText) ?? []
                if let searchedCity = searchedCities.first {
                    cities[searchedCity.name] = searchedCity
                    citiesKeys = Array(cities.keys)
                }
                tableView.reloadData()
            }
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.text = searchText
            .replacingOccurrences(of: "[^a-zA-ZÀ-ž ]", with: "", options: .regularExpression)
    }
}
