//
//  ViewController.swift
//  Peli Finder
//
//  Created by Jose Enrique Montañez Villanueva on 14/05/20.
//  Copyright © 2020 Jose Enrique Montañez Villanueva. All rights reserved.
//

import UIKit

class MoviesListViewController: UITableViewController {
    
    private var movies = [MovieViewModel]()
    private var moviesResult = [MovieViewModel]()
    private var isSearching = false
    
    private let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        addEmptyLabel()
        setupViews()
        loadFeedData()
        
    }
    
    private func loadFeedData() {
        addLoadingIndicator()
        RequestManager.shared.makeRequest(requestType: .feed) { (result) in
            switch result {
            case .success(let movies):
                self.movies = movies.map({ MovieViewModel(movie: $0) })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.removeEmptyLabel()
                    self.removeLoadingIndicator()
                }
                break
            case .failure(_):
                DispatchQueue.main.async {
                    self.addEmptyLabel()
                    self.removeLoadingIndicator()
                }
                break
            }
        }
    }
    
    private func addLoadingIndicator() {
        let loading = UIActivityIndicatorView(style: .large)
        loading.tag = 2
        loading.startAnimating()
        
        view.addSubview(loading)
        loading.center = CGPoint(x: view.center.x, y: view.center.y - 150)
    }
    
    private func removeLoadingIndicator() {
        (view.viewWithTag(2) as? UIActivityIndicatorView)?.removeFromSuperview()
    }
    
    private func setupViews() {
        setupNavBar()
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.register(MovieCell.self, forCellReuseIdentifier: MovieCell.identifier)
        tableView.keyboardDismissMode = .interactive
    }
    
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Peli Finder"
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "searchBarPlaceholder".localized
        
    }
    
    private func addEmptyLabel() {
        let emptyLabel = UILabel()
        emptyLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyLabel.text = "emptyContent".localized
        emptyLabel.font = .systemFont(ofSize: 22, weight: .light)
        emptyLabel.numberOfLines = 0
        emptyLabel.textAlignment = .center
        emptyLabel.tag = 1
        view.addSubview(emptyLabel)
        emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -150).isActive = true
        emptyLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        emptyLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    private func removeEmptyLabel() {
        (view.viewWithTag(1) as? UILabel)?.removeFromSuperview()
    }

}

// MARK: - Table View Data source
extension MoviesListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { isSearching ? moviesResult.count : movies.count }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let movieCell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else {
            let movieCell = MovieCell(style: .default, reuseIdentifier: MovieCell.identifier)
            movieCell.movieViewModel = isSearching ? moviesResult[indexPath.row] : movies[indexPath.row]
            return movieCell
        }
        movieCell.movieViewModel = isSearching ? moviesResult[indexPath.row] : movies[indexPath.row]
        return movieCell
    }
}


// MARK: - Table View Delegate
extension MoviesListViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.movieViewModel = isSearching ? moviesResult[indexPath.row] : movies[indexPath.row]
        
        navigationController?.pushViewController(movieDetailVC, animated: true)
    }
}

// MARK: - Search Bar Delegate
extension MoviesListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }
  
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
        moviesResult.removeAll()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard searchText != "" else {
            moviesResult.removeAll()
            tableView.reloadSections(IndexSet(integer: 0), with: .fade)
            return
        }
        
        let queryString = searchText.replacingOccurrences(of: " ", with: "+")
        
        RequestManager.shared.makeRequest(requestType: .movieSearch, query: queryString) { (result) in
            switch result {
            case .success(let movies):
                self.moviesResult = movies.map({ MovieViewModel(movie: $0)})
                DispatchQueue.main.async {
                    self.tableView.reloadSections(IndexSet(integer: 0), with: .fade)
                }
            case .failure:
                break
            }
        }
        
    }
    
}
