//
//  ViewController.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import UIKit


class MainViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private var searchTask: Task<(), Never>?
    private var cities: Cities = []

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true

        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cityCell", for: indexPath)
        let city = cities[indexPath.row]
        cell.textLabel!.text = "\(city.name), \(city.state), \(city.country)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailsViewController()
        detailVC.selectedCity = cities[indexPath.row]
        navigationController?.pushViewController(detailVC, animated: true)
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
                cities = await RESTManager.shared.getCities(for: strippedSearchText) ?? []
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
