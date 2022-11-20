//
//  ContentView.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-01-26.
//

import SwiftUI
import SDWebImageSwiftUI

struct HomeScreen: View {
    @EnvironmentObject var movieDB: MovieDatabase
    @State var nowPlayingSelection = 0
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    var body: some View {
        if movieDB.finishedLoading{
            NavigationView{
                ScrollView {
                    VStack{
                        nowPlaying
                        Divider().padding(.horizontal)
                        topRated
                        Divider().padding(.horizontal)
                        Upcoming
                    }
                }.navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Image("logo")
                                .resizable()
                                .scaledToFit()
                        }
                    }
            }.environmentObject(movieDB)
        } else {
            StartUpView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}

extension HomeScreen {
    private var topRated: some View {
        VStack {
            Text("Top Rated")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity ,alignment: .leading)
                .padding([.top, .leading])
                .font(.title3)
            ScrollView(.horizontal){
                LazyHStack(spacing: 15){
                    ForEach(movieDB.topRatedMovies, id: \.id) { movie in
                        NavigationLink {
                            MovieView().onAppear {
                                movieDB.getMovie(movieID: movie.id)
                            }
                        } label: {
                            VStack{
                                WebImage(url: movie.posterURL)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(12)
                                    .shadow(radius: 6)
                                    .frame(width: 100, height: 150)
                            }
                        }
                    }
                }.padding([.leading, .trailing, .bottom])
            }
        }
    }
    
    private var Upcoming: some View {
        VStack {
            Text("Upcoming")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity ,alignment: .leading)
                .padding([.top, .leading])
                .font(.title3)
            ScrollView(.horizontal){
                LazyHStack(spacing: 15){
                    ForEach(movieDB.upcomingMovies, id: \.id) { movie in
                        VStack{
                            NavigationLink {
                                MovieView().onAppear {
                                    movieDB.getMovie(movieID: movie.id)
                                }
                            } label: {
                                VStack{
                                    WebImage(url: movie.posterURL)
                                        .resizable()
                                        .scaledToFit()
                                        .cornerRadius(12)
                                        .shadow(radius: 6)
                                        .frame(width: 100, height: 150)
                                }
                            }
                        }
                    }
                }.padding([.leading, .trailing, .bottom])
            }
        }
    }
    
    private var nowPlaying: some View {
        VStack(alignment: .leading) {
            Text("Now Playing")
                .fontWeight(.bold)
                .frame(maxWidth: .infinity ,alignment: .leading)
                .padding([.top, .leading])
                .font(.title)
            if !movieDB.nowPlayingMovies.isEmpty{
                TabView(selection: $nowPlayingSelection){
                    ForEach(Array(movieDB.nowPlayingMovies.enumerated()), id: \.offset) { index ,movie in
                        VStack {
                            NavigationLink {
                                MovieView().onAppear {
                                    movieDB.getMovie(movieID: movie.id)
                                }
                            } label: {
                                WebImage(url: movie.backdropURL)
                                    .resizable()
                                    .scaledToFit()
                                    .shadow(radius: 6)
                                    .cornerRadius(12)
                                    .padding(.horizontal)
                                    .tag(index)
                            }
                            HStack {
                                Text(movie.title)
                                    .font(.title3)
                                    .fontWeight(.heavy)
                                Spacer()
                            }.padding(.leading)
                        } .offset(y: -20)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/3)
                .onReceive(timer) { _ in
                    withAnimation {
                        nowPlayingSelection = nowPlayingSelection < movieDB.nowPlayingMovies.count ? nowPlayingSelection + 1 : 0
                    }
                }
            }
        }
    }
    
}
