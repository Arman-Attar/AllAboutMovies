//
//  MovieDetail.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-12.
//

import Foundation

struct MovieDetail: Codable {
    let genres: [GenreInfo]
    let id: Int
    let title: String
    let overview: String
    let poster_path: String
    let release_date: String
    let runtime: Int
    let vote_average: Double
    
    var credit: Credits?
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(poster_path)")!
    }
    
    var releaseYear: String {
        return String(release_date.prefix(4))
    }
    
    var formattedRating: String {
            return String(format: "%.1f / 10", vote_average)
    }
    
}
