//
//  ViewController.swift
//  Weather
//
//  Created by bakeleet on 13/08/2024.
//

import UIKit

class MainViewController: UITableViewController {

    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        definesPresentationContext = true
        searchController.searchBar.searchBarStyle = .minimal
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
    }

}

