//
//  MovieManager.swift
//  MoviesApp
//
//  Created by Garima Saini on 2023-07-04.
//

import Foundation

enum MovieURL: String{
    case discover
    case none
}

enum NetworkingError: Error{
    case invalidURL
    case custom(error: Error)
    case invalidData
    case failedToDecode(error: Error)
}

//MARK: - MovieManager
final class MovieManager {
    
    static let shared = MovieManager()
    
    private init() {}
    
    //MARK: - Fetch Movie
    func performRequest<T: Codable>(type: T.Type, query searchText: String, movieURL: MovieURL, completion: @escaping (Result<T, Error>) -> Void){
        
        var url = ""
        
        switch movieURL{
        case .discover:
            url = URLAddress().discoverURL
        case .none:
            url = ""
        }
        
        if searchText != "" {
            guard let q = searchText.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {return}
            url = URLAddress().searchQueryURL + q
        }
        guard let urlString = URL(string: url) else {
            completion(.failure(NetworkingError.invalidURL))
            return
        }
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: urlString) { data, _, error in
            if let error {
                completion(.failure(NetworkingError.custom(error: error)))
                return
            }
            guard let data = data else {
                completion(.failure(NetworkingError.invalidData))
                return
            }
            do{
                let decoder = JSONDecoder()
                let res = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(res))
                }
            }catch{
                completion(.failure(NetworkingError.failedToDecode(error: error)))
            }
        }
        task.resume()
    }
}
