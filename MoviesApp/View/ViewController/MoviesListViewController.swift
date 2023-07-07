//
//  MoviesListViewController.swift
//  MoviesApp
//
//  Created by Garima Saini on 2023-07-04.
//

import UIKit
import Kingfisher

class MoviesListViewController: UIViewController {

    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchTableView: UITableView!
    
    //MARK: - Objects
    private var viewModel: MoviesListViewModel?
    private var movieArray : [Movie]?
    private var selectedMovie : Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Methods
    private func initialSetup() {
        viewModel = MoviesListViewModel()
        searchTableView.dataSource = self
        searchTableView.delegate = self
        searchBar.delegate = self
        fetchDiscoverMovies()
    }
    
    //Fetch Discovered Movie
    private func fetchDiscoverMovies(){
        viewModel?.getList(query: "", movieURL: .discover) { results in
            DispatchQueue.main.async { [weak self] in
                switch results{
                case.success(let movie):
                    self?.movieArray = movie.results
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.searchTableView.reloadData()
            }
        }
    }

}

//MARK: - TableViewDataSource
extension MoviesListViewController: UITableViewDataSource {
    
    //MARK: - Number of Rows in Section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = self.movieArray?.count else { return 0}
        return numberOfRows
    }
    
    //MARK: - Cell For Row at
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = searchTableView.dequeueReusableCell(withIdentifier: "searchTableViewCell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = self.movieArray?[indexPath.row]
        cell.movieTitle.text = movie?.title
        
        if let posterPath = movie?.poster_path{
            let downloadPosterImage = URL(string: "\(MovieConstants.baseImageURL)\(posterPath)")
            cell.posterImage.kf.setImage(with: downloadPosterImage)
        }
        
        if let voteAverage = movie?.vote_average, let voteCount = movie?.vote_count {
            cell.scoreLabel.text = String(format:"%.1f", voteAverage) + " (\(String(voteCount)))"
        }
        return cell
    }
}

//MARK: - TableViewDelegate
extension MoviesListViewController: UITableViewDelegate {
    //MARK: - Height For Row at
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TableViewConstants.SearchAndWatchlist.heightForRowAt
    }
}

//MARK: - SearchBarDelegate
extension MoviesListViewController: UISearchBarDelegate{
    //MARK: - Text Did Change
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            let query = searchText
            viewModel?.getList(query: query, movieURL: .none) { results in
                DispatchQueue.main.async { [weak self] in
                    switch results{
                    case.success(let movie):
                        self?.movieArray = movie.results
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    self?.searchTableView.reloadData()
                }
            }
        }
        else {
            self.fetchDiscoverMovies()
        }
    }
    
    //MARK: - SearchBar Cancel Button Clicked
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.fetchDiscoverMovies()
        self.view.endEditing(true)
    }

}


