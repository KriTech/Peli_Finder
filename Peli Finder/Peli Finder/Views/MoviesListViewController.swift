//
//  ViewController.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 14/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import UIKit

class MoviesListViewController: UITableViewController {
    
    let countries = ["Argentina", "Brasil", "Francia", "España", "Estados Unidos", "Honduras", "Japón", "México", "Portugal"]
    private var filteredCountries = [String]()
    private var isSearching = false
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupViews()
    }

    
    private func setupViews() {
        setupNavBar()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
//        searchBar.placeholder = "searchBarPlaceholder".localized
//        addEmptyLabel()
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Peli Finder"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
    }
    
    private func addEmptyLabel() {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "EmptyContent".localized
        emptyLabel.font = .systemFont(ofSize: 22, weight: .light)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.tag = 1
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        emptyLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emptyLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func removeEmptyLabel() {
        if let emptyLabel = view.viewWithTag(1) as? UILabel {
            emptyLabel.removeFromSuperview()
        }
    }

}

// MARK: - Table View Data source
extension MoviesListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int { 1 }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { isSearching ? filteredCountries.count : countries.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath)
        if isSearching {
            cell.textLabel?.text = filteredCountries[indexPath.row]
        } else {
            cell.textLabel?.text = countries[indexPath.row]
        }
        
        return cell
    }
}


// MARK: - Table View Delegate
extension MoviesListViewController {
    
}

// MARK: - Search Bar Delegate
extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadData()
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = countries.filter({ $0.lowercased().hasPrefix(searchText.lowercased()) })
        tableView.reloadData()
    }
    
}
