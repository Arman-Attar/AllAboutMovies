//
//  StartUpView.swift
//  AllAboutMovies
//
//  Created by Arman Zadeh-Attar on 2022-11-12.
//

import SwiftUI

struct StartUpView: View {
    @State var angle: Double = 0.0
        @State var isAnimating = false
        
        var foreverAnimation: Animation {
            Animation.linear(duration: 1.0)
                .repeatForever(autoreverses: false)
        }
    
    var body: some View {
        ZStack{
            Color.white
                .ignoresSafeArea()
            VStack{
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .rotationEffect(Angle(degrees: self.isAnimating ? 360.0 : 0.0))
                    .animation(self.foreverAnimation)
                Text("All About Movies")
                    .foregroundColor(.black)
                    .font(.title)
                    .fontWeight(.heavy)
            }
        }.onAppear {
            isAnimating.toggle()
        }
    }
}

struct StartUpView_Previews: PreviewProvider {
    static var previews: some View {
        StartUpView()
    }
}
