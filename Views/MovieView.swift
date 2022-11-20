//
//  MovieView.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-12.
//

import SwiftUI
import SDWebImageSwiftUI


struct MovieView: View {
    @EnvironmentObject var movieDB: MovieDatabase
    @Environment(\.dismiss) private var dismiss
    @State var startingOffSetY: CGFloat = UIScreen.main.bounds.height * 0.5
    @State var currentDragOffsetY: CGFloat = 0
    @State var endingOffsetY: CGFloat = 0
    var body: some View {
        ZStack(alignment: .top){
            if let movie = movieDB.movie {
                WebImage(url: movie.posterURL)
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .cornerRadius(6)
                VStack(alignment: .leading, spacing: 5){
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left").font(.title)
                        }.padding([.horizontal, .top])
                        HStack {
                            Text(movie.title)
                                .font(.title)
                                .fontWeight(.heavy)
                                .padding([.top, .horizontal])
                            Spacer()
                        }
                        HStack{
                            let genreCount = movie.genres.count
                            ForEach(movie.genres, id:\.id) { genre in
                                Text("\(genre.name)")
                                    .font(genreCount > 4 ? .footnote : (.system(size: 14)))
                                    .fontWeight(.bold)
                                Divider().frame(height: 10)
                            }
                            Spacer()
                            Text("⭐️").padding(.trailing)
                        }.padding(.horizontal)
                        HStack{
                            Text("Runtime: \(movie.runtime) min")
                                .font(.subheadline)
                                .fontWeight(.bold)
                            Spacer()
                            Text(movie.formattedRating)
                                .font(.subheadline)
                                .fontWeight(.bold)
                        }.padding(.horizontal)
                        Text(movie.overview)
                            .font(.body)
                            .padding([.horizontal, .top])
                        if let credit = movie.credit{
                            Text("Cast")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding([.top, .horizontal])
                            ScrollView(.horizontal) {
                                LazyHStack{
                                    ForEach(credit.cast, id:\.name) { member in
                                        VStack {
                                            if member.profile_path != nil {
                                            let formattedUrl = "\(credit.imageUrl)\(member.profile_path!)"
                                            WebImage(url: URL(string: formattedUrl))
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 70, height: 70)
                                                .clipShape(Circle())
                                                .shadow(radius: 5)
                                            } else {
                                                Image(systemName: "person.crop.circle.fill")
                                                    .font(.system(size: 70))
                                                    .frame(width: 70, height: 70)
                                                    .shadow(radius: 5)
                                            }
                                            Text(member.name)
                                                .font(.caption2)
                                                .fontWeight(.bold)
                                        }.padding(.horizontal)
                                        
                                    }
                                }
                            }.frame(height: 105)
                            Text("Director")
                                .font(.subheadline)
                                .fontWeight(.bold)
                                .padding([.top, .horizontal])
                            HStack {
                                if credit.directorImage != "" {
                                WebImage(url: URL(string: credit.directorImage))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 70)
                                    .clipShape(Circle())
                                    .shadow(radius: 10)
                                } else {
                                    Image(systemName: "person.crop.circle.fill")
                                        .font(.system(size: 70))
                                        .frame(width: 70, height: 70)
                                        .shadow(radius: 10)
                                }
                                Text(credit.director)
                                    .font(.caption2)
                                    .fontWeight(.bold)
                            }.padding(.horizontal)
                        }
                    Spacer()
                }
                .minimumScaleFactor(0.02)
                .frame(maxWidth: .infinity)
                .background(.thinMaterial)
                .cornerRadius(30)
                .offset(y: startingOffSetY)
                .offset(y: currentDragOffsetY)
                .offset(y: endingOffsetY)
                .gesture(
                    DragGesture()
                        .onChanged({ value in
                            currentDragOffsetY = value.translation.height
                        })
                        .onEnded({ value in
                            withAnimation(.spring()) {
                                if currentDragOffsetY < -150 {
                                    endingOffsetY = -startingOffSetY + 80
                                    currentDragOffsetY = 0
                                } else if endingOffsetY != 0 && currentDragOffsetY > 150 {
                                    endingOffsetY = 0
                                    currentDragOffsetY = 0
                                }
                                else {
                                    currentDragOffsetY = 0
                                }
                            }
                        })
                )
               
            } else {
                StartUpView()
            }
        }.ignoresSafeArea(edges: [.bottom, .top])
            .navigationBarHidden(true)
            
        
    }
}


