//
//  MovieData.swift
//  MoviesApp
//
//  Created by Garima Saini on 2023-07-04.
//

import Foundation

// MARK: - MovieData
struct MovieData: Codable {
    let results: [Movie]?
}

// MARK: - Result
struct Movie: Codable {
    let adult: Bool?
    let backdrop_path: String?
    let id: Int?
    let genre_ids : [Int]?
    let original_title, overview: String?
    let popularity: Double?
    let poster_path, release_date, title: String?
    let video: Bool?
    let vote_average: Double?
    let vote_count: Int?
}
