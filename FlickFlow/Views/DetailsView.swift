//
//  DetailsView.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/18/25.
//
import SwiftUI
import Kingfisher

struct DetailsView: View {
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack {
                KFImage(URL(string: "https://image.tmdb.org/t/p/w500/\(viewModel.movie.posterPath ?? "")"))
                    .resizable()
                    .placeholder {
                        Color.gray
                            .frame(maxWidth: .infinity)
                    }
                    .cancelOnDisappear(true)
                    .fade(duration: 0.25)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 20)
                Text(viewModel.movie.title)
                    .font(.largeTitle)
                Text(viewModel.movie.overview)
                    .padding(.horizontal, 20)
                Spacer()
            }
            .padding(.bottom, 40)
        }

    }
}


