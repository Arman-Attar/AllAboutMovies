//
//  Movie.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-01-26.
//

import Foundation

struct MovieResponse: Codable {
    
    let results: [Movie]
    
}

struct SearchMovieReponse: Codable {
    let results: [SearchedMovie]?
}

struct SearchedMovie: Codable{
    let id: Int?
    let title: String?
    let release_date: String?
    let backdrop_path: String?
    
    var backdropURL: String {
        if let url = backdrop_path {
            return "https://image.tmdb.org/t/p/w500/\(url)"
        } else {
            return ""
        }
    }
    
    var releaseYear: String {
        if let release_date = release_date {
            return String(release_date.prefix(4))
        } else {
            return "N/A"
        }
    }
}

struct Movie: Codable{
    let id: Int
    let title: String
    let overview: String
    let release_date: String
    let backdrop_path: String
    let poster_path: String
    let vote_average: Double
    let genre_ids: [Int]
    
    var posterURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(poster_path)")!
    }
    
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500/\(backdrop_path)")!
    }
    
    var releaseYear: String {
        return String(release_date.prefix(4))
    }
    
}

struct GenreInfo: Codable{
    let id: Int
    let name: String
}

