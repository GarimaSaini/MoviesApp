//
//  MoviesListViewModel.swift
//  MoviesApp
//
//  Created by Garima Saini on 2023-07-04.
//

import Foundation

protocol MoviesListService {
    func getList(query searchText: String, movieURL: MovieURL, completion: @escaping (Result<MovieData, Error>) -> Void)
}

class MoviesListViewModel: MoviesListService {
    
    //MARK: - get list from API
    func getList(query searchText: String, movieURL: MovieURL, completion: @escaping (Result<MovieData, Error>) -> Void) {
        MovieManager.shared.performRequest(type: MovieData.self, query: searchText, movieURL: movieURL) { results in
            switch results{
            case.success(let genres):
                completion(.success(genres))
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
