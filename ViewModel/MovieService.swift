//
//  MovieService.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-01-26.
//

import Foundation
import UIKit

class MovieDatabase: ObservableObject {
    @Published var topRatedMovies = [Movie]()
    @Published var upcomingMovies = [Movie]()
    @Published var nowPlayingMovies = [Movie]()
    @Published var finishedLoading = false
    @Published var movie: MovieDetail?
    @Published var searchResults = [SearchedMovie]()
    
    init() {
        getTopRatedMovies()
        getUpcomingMovies()
        getNowPlaying()
    }
    
    
    
    
    private func getTopRatedMovies() {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/top_rated?api_key=\(apiKey)&language=en-US&page=1") {
            URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                if let data = data {
                    do{
                        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            self?.topRatedMovies = decoded.results
                            self?.finishedLoading = true
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
            }.resume()
        }
    }
    
    private func getUpcomingMovies() {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)&language=en-US&page=1"){
            
            URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            self?.upcomingMovies = decoded.results
                            self?.finishedLoading = true
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    private func getNowPlaying() {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)&language=en-US&page=1"){
            
            URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(MovieResponse.self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            self?.nowPlayingMovies = decoded.results
                            self?.finishedLoading = true
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
     func getMovie(movieID: Int) {
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)?api_key=\(apiKey)&language=en-US&page=1"){
            
            URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(MovieDetail.self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            self?.movie = decoded
                        }
                        self.getCredits(movieID: movieID) { [weak self] data in
                            if let data = data {
                                self?.movie?.credit = data
                                let simpleArray = Array(data.cast.prefix(10))
                                self?.movie?.credit?.cast = simpleArray
                            }
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        return
                    }
                }
            }.resume()
        }
    }
    
    private func getCredits(movieID: Int, completionHandler: @escaping (Credits?) -> Void) {
      
        if let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)"){
            URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    print(err.localizedDescription)
                    completionHandler(nil)
                    return
                }
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(Credits.self, from: data)
                        DispatchQueue.main.async {
                            completionHandler(decoded)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        completionHandler(nil)
                        return
                    }
                }
            }.resume()
        }
    }
    
    func searchMovie(query: String, completion: @escaping (Bool) -> Void) {
        let formattedQuery = query.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(formattedQuery)"){
            URLSession.shared.dataTask(with: url) { data, _, err in
                if let err = err {
                    print(err.localizedDescription)
                    completion(false)
                    return
                }
                
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode(SearchMovieReponse.self, from: data)
                        DispatchQueue.main.async { [weak self] in
                            if let resultArray = decoded.results{
                                self?.searchResults = resultArray
                            } else {
                                self?.searchResults = []
                            }
                            completion(true)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                        completion(false)
                        return
                    }
                }
            }.resume()
        }
    }
}
