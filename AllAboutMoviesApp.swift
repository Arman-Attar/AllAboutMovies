//
//  AllAboutMoviesApp.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-01-26.
//

import SwiftUI

@main
struct AllAboutMoviesApp: App {
    @StateObject var movieDB = MovieDatabase()
    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(movieDB)
        }
    }
}
