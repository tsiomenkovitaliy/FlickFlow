//
//  ContentView.swift
//  FlickFlow
//
//  Created by Vitalii Tsiomenko on 3/17/25.
//

import SwiftUI
import CoreData
import Kingfisher

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject private var viewModel: HomeViewModel
    @EnvironmentObject private var router: Router
    
    var body: some View {
        NavigationStack(path: $router.path){
            VStack {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.movies) { movie in
                            MovieRow(movie: movie)
                                .onAppear {
                                    if !viewModel.isLoading && movie == viewModel.movies.last  {
                                        viewModel.incrementPage()
                                    }
                                }
                                .onTapGesture {
                                    router.push(to: .detailsView(movie))
                                }
                        }
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity)
                        .transition(.opacity)
                        .animation(.easeInOut, value: viewModel.isLoading)
                        .padding(.vertical, 10)
                }
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .detailsView(let movie):
                    let detailsViewModel = DetailsViewModel(movie: movie)
                    DetailsView(viewModel: detailsViewModel)
                }
            }
            .alert("Ошибка", isPresented: Binding<Bool>(
                get: { viewModel.error != nil },
                set: { _ in viewModel.error = nil }
            )) {
                Button("Повторить") {
                    Task { await viewModel.fetchMovies() }
                }
                Button("Отмена", role: .cancel) {}
            } message: {
                Text(viewModel.error?.localizedDescription ?? "Неизвестная ошибка")
            }
        }
    }
}

#Preview {
    HomeView()
//        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        .environmentObject(HomeViewModel())
}
