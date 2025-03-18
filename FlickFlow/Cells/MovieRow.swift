//
//  MovieRow.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//
import SwiftUI
import Kingfisher

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            KFImage(URL(string: "https://image.tmdb.org/t/p/w200/\(movie.posterPath ?? "")"))
                .resizable()
                .placeholder { 
                    Color.gray
                        .frame(width: 80, height: 120)
                }
                .cancelOnDisappear(true)
                .fade(duration: 0.25)
                .frame(width: 80, height: 120)
                .cornerRadius(8)
            
            Text(movie.title)
                .font(.headline)
            
            Spacer()
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
    }
}
