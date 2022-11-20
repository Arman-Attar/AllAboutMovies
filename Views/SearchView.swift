//
//  SearchView.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-14.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchView: View {
    @State var searchField = ""
    @State var loaded = false
    @EnvironmentObject var movieDB: MovieDatabase
    var body: some View {
        NavigationView {
            VStack {
                searchBar.onChange(of: searchField) { newValue in
                    movieDB.searchMovie(query: searchField) { result in
                        if result {
                            loaded = true
                        } else {
                            loaded = false
                        }
                    }
                }
                if searchField != ""{
                    HStack{
                        Text("Top Results")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding()
                        Spacer()
                    }
                    if movieDB.searchResults.isEmpty {
                        Text("No matches found")
                    } else {
                        ScrollView{
                            ForEach(movieDB.searchResults, id: \.id) { movie in
                                NavigationLink {
                                    MovieView().onAppear {
                                        movieDB.getMovie(movieID: movie.id!)
                                    }
                                } label: {
                                    HStack{
                                        if movie.backdropURL != ""{
                                            WebImage(url: URL(string: movie.backdropURL))
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .shadow(radius: 10,y: 10)
                                        } else {
                                            Image(systemName: "film.circle")
                                                .font(.system(size: 50))
                                                .shadow(radius: 10,y: 10)
                                                .frame(width: 50, height: 50)
                                        }
                                        Text(movie.title!)
                                            .font(.subheadline)
                                            .fontWeight(.bold)
                                            .multilineTextAlignment(.leading)
                                        Text("(\(movie.releaseYear))")
                                            .font(.footnote)
                                            .foregroundColor(.gray)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                    }.padding(.horizontal).foregroundColor(.secondary)
                                }
                                Divider().padding(.horizontal)
                            }
                        }
                    }
                }
                Spacer()
            }.navigationBarHidden(true)
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

extension SearchView {
    private var searchBar: some View {
        HStack{
            TextField("Search", text: $searchField).padding(.leading, 30)
        }
        .padding()
        .background(
            Color(.systemGray5)
        )
        .cornerRadius(6)
        .padding(.horizontal)
        .overlay(
            HStack{
                Image(systemName: "magnifyingglass")
                Spacer()
                Button {
                    searchField = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }

            }.padding(.horizontal, 32)
                .foregroundColor(.gray)
        )
    }
}
