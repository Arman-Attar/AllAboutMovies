//
//  MainView.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-14.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView{
            HomeScreen()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
