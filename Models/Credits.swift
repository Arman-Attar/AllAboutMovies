//
//  MovieCredit.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-13.
//

import Foundation

struct Credits: Codable {
    let id: Int
    var cast: [Cast]
    var crew: [Crew]
    
    var imageUrl: String {
        return "https://image.tmdb.org/t/p/w500"
    }
    
    var director: String {
        if let director = crew.first(where: {$0.job == "Director"}){
            return director.name
        } else {
            return "N/A"
        }
    }
    
    var directorImage: String {
        if let director = crew.first(where: {$0.job == "Director"}) {
            if let urlPath = director.profile_path {
                return "https://image.tmdb.org/t/p/w500\(urlPath)"
            } else {
                return ""
            }
        }
        return ""
    }
}


struct Cast: Codable {
    let name: String
    let profile_path: String?
}

struct Crew: Codable {
    let name: String
    let profile_path: String?
    let job: String
    
}
